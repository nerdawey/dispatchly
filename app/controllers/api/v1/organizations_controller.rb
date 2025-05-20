class Api::V1::OrganizationsController < ApplicationController
    load_and_authorize_resource
    before_action :set_organization, only: [ :show, :update, :destroy ]

    def index
        @organizations = Organization.all
        render json: { organizations: @organizations }
    end
    def show
        render json: @organization
    end
    def create
        @organization = Organization.new(organization_params)
        if @organization.save
            render json: @organization, status: :created
        else
            render json: { errors: @organization.errors.full_messages }, status: :unprocessable_entity
        end
    end
    def update
        if @organization.update(organization_params)
            render json: @organization
        else
            render json: { errors: @organization.errors.full_messages }, status: :unprocessable_entity
        end
    end
    def destroy
        ActiveRecord::Base.transaction do
            # Delete all dependent records
            @organization.users.destroy_all
            @organization.locations.destroy_all
            @organization.vehicles.destroy_all
            @organization.products.destroy_all
            @organization.orders.destroy_all
            @organization.trips.destroy_all

            # Finally delete the organization
            @organization.destroy
            head :no_content
        end
    rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def set_organization
        @organization = Organization.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Organization not found" }, status: :not_found
    end

    def organization_params
        params.expect(
            organization: [ :name,
            :address,
            :contact_email,
            :contact_phone,
            :subscription_tier,
            :status ]
        )
    end
end
