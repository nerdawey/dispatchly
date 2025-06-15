class Api::V1::UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    if current_user.super_admin?
      @users = User.all
    else
      @users = current_user.organization.users
    end
    render json: { users: @users.as_json(include: { organization: { only: [ :id, :name ] } }) }
  end

  def show
    render json: @user
  end

  def create
    # Prevent non-super_admins from creating a super_admin
    if params[:user][:role] == "super_admin" && !current_user.super_admin?
      return render json: { error: "Only super admins can create super admins." }, status: :forbidden
    end

    if params[:user][:role] == "super_admin"
      @user = User.new(user_params)
    elsif current_user.super_admin?
      # If super admin is creating a user, use the organization_id from params
      organization = Organization.find(params[:user][:organization_id])
      @user = organization.users.new(user_params)
    else
      @user = current_user.organization.users.new(user_params)
    end

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
    params.expect(user: [ :name, :email_address, :password, :role, :organization_id ])
  end
end
