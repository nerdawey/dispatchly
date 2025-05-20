class Api::V1::VehiclesController < ApplicationController
    load_and_authorize_resource
    before_action :set_vehicle, only: [ :show, :update, :destroy ]

    # GET /api/v1/vehicles
    def index
      @vehicles = current_user.organization.vehicles
      render json: { vehicles: @vehicles }
    end

    # GET /api/v1/vehicles/:id
    def show
      render json: @vehicle
    end

    # POST /api/v1/vehicles
    def create
      @vehicle = current_user.organization.vehicles.new(vehicle_params)
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
      ActiveRecord::Base.transaction do
        @vehicle.assignments.destroy_all
        @vehicle.destroy
        head :no_content
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def set_vehicle
      @vehicle = current_user.organization.vehicles.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Vehicle not found" }, status: :not_found
    end

    def vehicle_params
      params.expect(
        vehicle: [ :name,
        :plate_number,
        :capacity_volume,
        :capacity_weight,
        :min_temp,
        :max_temp,
        :organization_id,
        :current_location_id,
        :status,
        :cost_per_km ]
      )
    end
end
