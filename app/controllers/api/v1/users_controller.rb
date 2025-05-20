class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    @users = current_user.organization.users
    render json: { users: @users }
  end

  def show
    render json: @user
  end

  def create
    @user = current_user.organization.users.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = current_user.organization.users.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def user_params
    params.expect(user: [ :email_address, :password, :role, :organization_id ])
  end
end
