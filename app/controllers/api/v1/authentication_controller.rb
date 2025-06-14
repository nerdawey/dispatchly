# app/controllers/api/v1/authentication_controller.rb
class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]
  
  def login
    user_params = params.require(:authentication).permit(:username, :password)
    @user = User.find_by(email_address: user_params[:username])
  
    if @user&.authenticate(user_params[:password])
      @user.update(last_login_at: Time.current)
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.zone.now + 24.hours.to_i
  
      response = {
        token: token,
        exp: time.strftime("%m-%d-%Y %H:%M"),
        user_id: @user.id,
        role: @user.role
      }
  
      # Include organization_id only if not super_admin
      response[:organization_id] = @user.organization_id unless @user.super_admin?
  
      render json: response, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  end