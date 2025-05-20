class Api::V1::OrganizationsController < ApplicationController
    before_action :set_organization, only: [:show, :update, :destroy]

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
            @organization.locations.destroy_all
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
        params.require(:organization).permit(:name, :address, :contact_email, :contact_phone, :subscription_tier, :status)
    end
end
