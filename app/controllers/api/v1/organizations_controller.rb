class Api::V1::OrganizationsController < ApplicationController
    load_and_authorize_resource
    before_action :set_organization, only: [ :show, :update, :destroy ]

    def index
        @organizations = if current_user.super_admin?
            Organization.all
        else
            Organization.where(id: current_user.organization_id)
        end
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
        if @organization.destroy
            head :no_content
        else
            render json: { errors: @organization.errors.full_messages }, status: :unprocessable_entity
        end
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
