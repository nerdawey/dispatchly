# app/controllers/api/v1/trip_controller.rb
class Api::V1::TripController < ApplicationController
    before_action :set_trip, only: [:show, :update, :destroy, :optimize]
    
    # GET /api/v1/trip
    def index
      @trip = current_user.organization.trip
      render json: @trip
    end
    
    # GET /api/v1/trip/:id
    def show
      render json: @trip, include: [:assignments]
    end
    
    # POST /api/v1/trip
    def create
      @trip = DispatchPlan.new(trip_params)
      @trip.organization = current_user.organization
      
      if @trip.save
        render json: @trip, status: :created
      else
        render json: { errors: @trip.errors }, status: :unprocessable_entity
      end
    end
    
    # PUT /api/v1/trip/:id
    def update
      if @trip.update(trip_params)
        render json: @trip
      else
        render json: { errors: @trip.errors }, status: :unprocessable_entity
      end
    end
    
    # DELETE /api/v1/trip/:id
    def destroy
      @trip.destroy
      head :no_content
    end
    
    # POST /api/v1/trip/:id/optimize
    def optimize
      begin
        dispatcher = DispatchAlgorithmService.new(@trip.id)
        assignments = dispatcher.optimize
        
        render json: { 
          message: "Dispatch plan optimized successfully", 
          assignments_count: assignments.count,
          trip: @trip
        }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
    
    private
    
    def set_trip
      @trip = current_user.organization.trip.find(params[:id])
    end
    
    def trip_params
      params.require(:trip).permit(:name, :scheduled_date, :status)
    end
  end