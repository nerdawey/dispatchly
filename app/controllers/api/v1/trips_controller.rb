# app/controllers/api/v1/trip_controller.rb
class Api::V1::TripsController < ApplicationController
    before_action :set_trip, only: [:show, :update, :destroy, :optimize, :status, :complete]
    
    # GET /api/v1/trip
    def index
      if current_user.super_admin?
        @trips = Trip.includes(:vehicle, :orders).order(created_at: :desc)
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
      status_changing_to_completed = trip_params[:status].to_s.in?(["completed", "ended"])
      filtered_params = trip_params.except(:end_time)
      @trip.assign_attributes(filtered_params)
      @trip.end_time = Time.current if status_changing_to_completed
      if @trip.save
        # Update Redis cache
        RedisService.track_active_trip(@trip.id, {
          vehicle_id: @trip.vehicle_id,
          order_ids: @trip.orders.map(&:id),
          status: @trip.status,
          updated_at: Time.current
        })
        render json: @trip
      else
        Rails.logger.error "Trip update failed: #{@trip.errors.full_messages.join(', ')}"
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

    # POST /api/v1/trips/propose
    def propose
      # Get orders from params
      order_ids = params[:order_ids]
      orders = current_user.organization.orders.where(id: order_ids)

      # Use the actual dispatch algorithm service
      available_vehicles = current_user.organization.vehicles.available
      result = DispatchAlgorithmService.new(orders, available_vehicles).call

      # Serialize trips for the frontend without saving to DB
      trips_json = result.map.with_index do |assignment, index|
        {
          id: index + 1, # Temporary ID for frontend reference
          vehicle_id: assignment[:vehicle].id,
          vehicle: { 
            id: assignment[:vehicle].id,
            plate_number: assignment[:vehicle].plate_number 
          },
          order_ids: assignment[:orders].map(&:id),
          orders: assignment[:orders].map do |order|
            {
              id: order.id,
              order_number: order.order_number,
              total_weight: order.total_weight,
              products: order.order_items.map do |item|
                {
                  id: item.product.id,
                  sku: item.product.sku,
                  quantity: item.quantity
                }
              end
            }
          end,
          total_weight: assignment[:orders].sum(&:total_weight),
          total_distance: assignment[:total_distance],
          estimated_duration: assignment[:estimated_duration]
        }
      end

      # Store in Redis
      redis_key = RedisService.store_proposed_trips(current_user.id, {
        trips: trips_json,
        order_ids: order_ids,
        created_at: Time.current
      })

      render json: {
        proposed_trips: trips_json,
        redis_key: redis_key
      }
    rescue => e
      Rails.logger.error "Error in propose action: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: e.message }, status: :unprocessable_entity
    end

    # POST /api/v1/trips/confirm
    def confirm
      # Get proposed trips from Redis
      proposed_data = RedisService.get_proposed_trips(current_user.id)
      return render json: { error: "No proposed trips found" }, status: :not_found unless proposed_data

      # Get confirmed trip IDs from params
      confirmed_trip_ids = params[:confirmed_trip_ids]
      return render json: { error: "No trips selected for confirmation" }, status: :bad_request if confirmed_trip_ids.blank?

      # Filter trips to only include confirmed ones
      trips_to_save = proposed_data["trips"].select { |trip| confirmed_trip_ids.include?(trip["id"]) }

      # Save confirmed trips to database
      saved_trips = []
      errors = []
      updated_orders = []

      ActiveRecord::Base.transaction do
        trips_to_save.each do |trip_data|
          begin
            # Create the trip
            trip = current_user.organization.trips.create!(
              vehicle_id: trip_data["vehicle_id"],
              status: "pending",
              scheduled_date: Date.current,
              name: trip_data["name"] || "Trip ##{SecureRandom.hex(4)}",
              start_time: Time.current,
              end_time: nil
            )

            trip_data["order_ids"].each do |order_id|
              begin
                order = current_user.organization.orders.find(order_id)
                Rails.logger.info "[CONFIRM] Updating Order #{order.id}: current status=#{order.status}, trip_id=#{order.trip_id}"
                order.update!(
                  trip_id: trip.id,
                  status: "dispatched"
                )
                Rails.logger.info "[CONFIRM] Order #{order.id} updated! New status=#{order.status}, trip_id=#{order.trip_id}"
                updated_orders << { id: order.id, status: order.status, trip_id: order.trip_id }
              rescue => order_error
                Rails.logger.error "[CONFIRM] Failed to update Order #{order_id}: #{order_error.message}"
                Rails.logger.error order_error.backtrace.join("\n")
                errors << { order_id: order_id, error: order_error.message, full_messages: (order.respond_to?(:errors) ? order.errors.full_messages : []) }
                raise ActiveRecord::Rollback
              end
            end

            saved_trips << trip
          rescue => e
            Rails.logger.error "[CONFIRM] Failed to create trip for vehicle #{trip_data['vehicle_id']}: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            errors << { trip_id: trip_data["id"], error: e.message }
            raise ActiveRecord::Rollback
          end
        end
      end

      # Clear Redis data
      RedisService.clear_proposed_trips(current_user.id)

      if errors.any?
        render json: {
          saved_trips: saved_trips,
          updated_orders: updated_orders,
          errors: errors
        }, status: :partial_content
      else
        render json: { 
          message: "Trips confirmed successfully",
          trips: saved_trips.as_json(include: [:vehicle, :orders]),
          updated_orders: updated_orders
        }, status: :created
      end
    end
    
    private
    
    def set_trip
      @trip = current_user.organization.trips.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Trip not found" }, status: :not_found
    end
    
    def trip_params
      params.expect(
        trip: [:name,
        :vehicle_id,
        :status,
        :scheduled_date,
        :start_time,
        :end_time,
        order_ids: []]
      )
    end
  end