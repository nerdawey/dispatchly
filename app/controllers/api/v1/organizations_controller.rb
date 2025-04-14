class Api::V1::OrganizationsController < ApplicationController
    def index
        @organizations = Organization.all
        render json: @organizations, status: :ok
    end
    def show
        @organization = Organization.find(params[:id])
        render json: @organization, status: :ok
    end
    def create
        @organization = Organization.new(organization_params)
        if @organization.save
            render json: @organization, status: :created
        else
            render json: @organization.errors, status: :unprocessable_entity
        end
    end
    def update
        @organization = Organization.find(params[:id])
        if @organization.update(organization_params)
            render json: @organization, status: :ok
        else
            render json: @organization.errors, status: :unprocessable_entity
        end
    end
    def destroy
        @organization = Organization.find(params[:id])
        if @organization.destroy
            render json: { message: "Organization deleted successfully" }, status: :ok
        else
            render json: { error: "Failed to delete organization" }, status: :unprocessable_entity
        end
    end
end
