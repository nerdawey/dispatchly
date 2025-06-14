# app/controllers/api/v1/trip_controller.rb
class Api::V1::TripsController < ApplicationController
    before_action :set_trip, only: [:show, :update, :destroy, :optimize, :status, :complete]
    
    # GET /api/v1/trip
    def index
      if current_user.super_admin?
        @trips = Trip.all.includes(:vehicle, :orders).order(created_at: :desc)
      else
        @trips = current_user.organization.trips
          .includes(:vehicle, :orders)
          .order(created_at: :desc)
      end

      render json: {
        trips: @trips.as_json(include: [:vehicle, :orders])
      }
    end
    
    # GET /api/v1/trip/:id
    def show
      # Get trip data from Redis cache first
      cached_trip = RedisService.get_active_trip(@trip.id)
      
      if cached_trip
        render json: {
          trip: @trip.as_json(include: [:vehicle, :orders]),
          real_time_data: cached_trip
        }
      else
        render json: @trip.as_json(include: [:vehicle, :orders])
      end
    end
    
    # POST /api/v1/trip
    def create
      # Rate limit dispatch requests
      if RedisService.rate_limit?("dispatch_requests:#{current_user.id}", limit: 100, period: 1.hour)
        return render json: { error: "Rate limit exceeded" }, status: :too_many_requests
      end

      begin
        # Get orders to dispatch
        order_ids = params[:order_ids] || []
        orders = current_user.organization.orders.where(id: order_ids)
        
        if orders.empty?
          return render json: { error: "No valid orders found" }, status: :not_found
        end

        # Get available vehicles for the current organization
        available_vehicles = current_user.organization.vehicles.available

        if available_vehicles.empty?
          return render json: { error: "No vehicles available" }, status: :unprocessable_entity
        end

        # Create dispatch and trips
        dispatch_service = DispatchAlgorithmService.new(orders, available_vehicles)
        trips = dispatch_service.call

        # Track dispatch attempt
        RedisService.track_dispatch_attempt(
          SecureRandom.uuid,
          {
            user_id: current_user.id,
            order_ids: orders.map(&:id),
            vehicle_ids: available_vehicles.map(&:id),
            trip_ids: trips.map(&:id),
            timestamp: Time.current
          }
        )

        # Track trips in Redis
        trips.each do |trip|
          RedisService.track_active_trip(trip.id, {
            vehicle_id: trip.vehicle_id,
            order_ids: trip.orders.map(&:id),
            status: "created",
            created_at: Time.current
          })
        end

        render json: {
          message: "Trips created successfully",
          trips: trips.as_json(include: [:vehicle, :orders])
        }, status: :created
      rescue StandardError => e
        Rails.logger.error("Trip creation failed: #{e.message}")
        
        # Create failed dispatch record
        failed_dispatch = FailedDispatch.create!(
          orders: orders,
          reason: e.message,
          attempted_at: Time.current
        )

        # Notify about failure
        NotificationService.new.notify_dispatch_failure(orders)

        render json: { 
          error: e.message,
          failed_dispatch_id: failed_dispatch.id
        }, status: :unprocessable_entity
      end
    end
    
    # PUT /api/v1/trip/:id
    def update
      if @trip.update(trip_params)
        # Update Redis cache
        RedisService.track_active_trip(@trip.id, {
          vehicle_id: @trip.vehicle_id,
          order_ids: @trip.orders.map(&:id),
          status: @trip.status,
          updated_at: Time.current
        })

        render json: @trip
      else
        render json: { errors: @trip.errors }, status: :unprocessable_entity
      end
    end
    
    # DELETE /api/v1/trip/:id
    def destroy
      # Remove from Redis cache
      RedisService.remove_active_trip(@trip.id)
      
      @trip.destroy
      head :no_content
    end
    
    # POST /api/v1/trip/:id/optimize
    def optimize
      begin
        dispatcher = DispatchAlgorithmService.new(@trip.orders, [@trip.vehicle])
        optimized_orders = dispatcher.call
        
        # Update trip with optimized route
        @trip.update!(
          optimized_route: optimized_orders.map(&:id),
          optimized_at: Time.current
        )

        # Update Redis cache
        RedisService.track_active_trip(@trip.id, {
          vehicle_id: @trip.vehicle_id,
          order_ids: optimized_orders.map(&:id),
          status: "optimized",
          optimized_at: Time.current
        })
        
        render json: { 
          message: "Trip optimized successfully", 
          trip: @trip.as_json(include: [:vehicle, :orders])
        }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def status
      cached_trip = RedisService.get_active_trip(@trip.id)
      
      if cached_trip
        render json: {
          status: cached_trip["status"],
          current_location: cached_trip["current_location"],
          updated_at: cached_trip["updated_at"]
        }
      else
        render json: {
          status: @trip.status,
          message: "No real-time data available"
        }
      end
    end

    def complete
      if @trip.update(status: "completed", completed_at: Time.current)
        # Remove from active trips in Redis
        RedisService.remove_active_trip(@trip.id)
        
        # Notify about completion
        NotificationService.new.notify_trip_completion(@trip)
        
        render json: { message: "Trip marked as completed" }
      else
        render json: { errors: @trip.errors }, status: :unprocessable_entity
      end
    end
    
    private
    
    def set_trip
      @trip = current_user.organization.trips.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Trip not found" }, status: :not_found
    end
    
    def trip_params
      params.require(:trip).permit(
        :name,
        :vehicle_id,
        :status,
        :scheduled_date,
        order_ids: []
      )
    end
  end