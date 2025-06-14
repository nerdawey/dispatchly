class Api::V1::OrganizationsController < ApplicationController
    load_and_authorize_resource
    before_action :set_organization, only: [ :show, :update, :destroy ]

    def index
        if current_user.super_admin?
            @organizations = Organization.all
        else
            @organizations = Organization.where(id: current_user.organization_id)
        end
        render json: { organizations: @organizations }
    end
    def show
        render json: @organization
    end
    def create
        @organization = Organization.new(organization_params)
        if @organization.save
            # Create org admin user if admin_email and password are provided
            admin_email = params[:organization][:admin_email]
            admin_password = params[:organization][:password]
            if admin_email.present? && admin_password.present?
                User.create!(
                    email_address: admin_email,
                    password: admin_password,
                    role: :org_admin,
                    organization: @organization
                )
            end
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
            :contact_email,
            :contact_phone,
            :status ]
        )
    end
end
