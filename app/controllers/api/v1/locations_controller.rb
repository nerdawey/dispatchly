class Api::V1::LocationsController < ApplicationController
    load_and_authorize_resource
    before_action :set_location, only: [ :show, :update, :destroy ]

    # GET /api/v1/locations
    def index
      if current_user.super_admin?
        @locations = Location.all
      else
      @locations = current_user.organization.locations
      end
      render json: { locations: @locations }
    end

    # GET /api/v1/locations/:id
    def show
      render json: @location
    end

    # POST /api/v1/locations
    def create
      @location = if current_user.super_admin?
        Location.new(location_params)
      else
        current_user.organization.locations.build(location_params)
      end

      if @location.save
        render json: @location, status: :created
      else
        render json: { errors: @location.errors }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/locations/:id
    def update
      if @location.update(location_params)
        render json: @location
      else
        render json: { errors: @location.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/locations/:id
    def destroy
      @location.destroy
      head :no_content
    end

    private

    def set_location
      @location = if current_user.super_admin?
        Location.find(params[:id])
      else
        current_user.organization.locations.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Location not found" }, status: :not_found
    end

    def location_params
      params.expect(
        location: [ :name,
        :address,
        :city,
        :latitude,
        :longitude,
        :location_type ]
      )
    end
end
