class Api::V1::LocationsController < ApplicationController
    before_action :set_location, only: [ :show, :update, :destroy ]

    # GET /api/v1/locations
    def index
      @locations = current_user.organization.locations
      render json: { locations: @locations }
    end

    # GET /api/v1/locations/:id
    def show
      render json: @location
    end

    # POST /api/v1/locations
    def create
      @location = current_user.organization.locations.new(location_params)
      if @location.save
        render json: @location, status: :created
      else
        render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/locations/:id
    def update
      if @location.update(location_params)
        render json: @location
      else
        render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/locations/:id
    def destroy
      render json: { error: 'Deleting locations is not allowed.' }, status: :method_not_allowed
    end

    private

    def set_location
      @location = current_user.organization.locations.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Location not found" }, status: :not_found
    end

    def location_params
      params.require(:location).permit(
        :name,
        :address,
        :latitude,
        :longitude,
        :organization_id
      )
    end
end
