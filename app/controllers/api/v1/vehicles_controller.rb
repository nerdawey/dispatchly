class Api::V1::VehiclesController < ApplicationController
    load_and_authorize_resource
    before_action :set_vehicle, only: [ :show, :update, :destroy, :activate ]

    # GET /api/v1/vehicles
    def index
      if current_user.super_admin?
        @vehicles = Vehicle.all
      else
        @vehicles = current_user.organization.vehicles
      end
      render json: { vehicles: @vehicles.as_json(include: { organization: { only: [ :id, :name ] } }) }
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
        if @vehicle.destroy
          head :no_content
        else
          raise ActiveRecord::RecordNotDestroyed.new("Failed to destroy vehicle", @vehicle)
        end
      end
    rescue ActiveRecord::RecordNotDestroyed => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    # POST /api/v1/vehicles/:id/activate
    def activate
      if @vehicle.update(status: "active")
        render json: { message: "Vehicle activated successfully" }
      else
        render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_vehicle
      @vehicle = current_user.organization.vehicles.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Vehicle not found" }, status: :not_found
    end

    def vehicle_params
      params.expect(
        vehicle: [ :plate_number,
        :capacity_volume,
        :capacity_weight,
        :organization_id,
        :current_location_id,
        :status,
        :cost_per_km,
        :model,
        :year,
        :box_type,
        :last_maintenance_date,
        :freezing_available,
        :box_volume ]
      )
    end
end
