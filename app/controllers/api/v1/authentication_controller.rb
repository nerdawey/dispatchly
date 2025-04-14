# app/controllers/api/v1/authentication_controller.rb
class Api::V1::AuthenticationController < ApplicationController
  
  def login
    user_params = params.require(:authentication).permit(:email_address, :password)
    @user = User.find_by(email_address: user_params[:email_address])
  
    if @user&.authenticate(user_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
  
      response = {
        token: token,
        exp: time.strftime("%m-%d-%Y %H:%M"),
        user_id: @user.id
      }
  
      # Include organization_id only if not super_admin
      response[:organization_id] = @user.organization_id unless @user.super_admin?
  
      render json: response, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  end