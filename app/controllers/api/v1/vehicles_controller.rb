class Api::V1::VehiclesController < ApplicationController
    before_action :set_vehicle, only: [ :show, :update, :destroy ]

    # GET /api/v1/vehicles
    def index
      @vehicles = Vehicle.all
      render json: @vehicles
    end

    # GET /api/v1/vehicles/:id
    def show
      render json: @vehicle
    end

    # POST /api/v1/vehicles
    def create
      @vehicle = Vehicle.new(vehicle_params)
      if @vehicle.save
        render json: @vehicle, status: :created
      else
        render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/vehicles/:id
    def update
      if @vehicle.update(vehicle_params)
        render json: @vehicle
      else
        render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/vehicles/:id
    def destroy
      @vehicle.destroy
      head :no_content
    end

    private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Vehicle not found" }, status: :not_found
    end

    def vehicle_params
      params.require(:vehicle).permit(:capacity, :organization_id)
    end
end
