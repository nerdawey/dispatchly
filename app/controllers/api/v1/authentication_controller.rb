# app/controllers/api/v1/authentication_controller.rb
class Api::V1::AuthenticationController < ApplicationController
    skip_before_action :authorize_request, only: :login
  
    def login
      @user = User.find_by(email: params[:email])
      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       user_id: @user.id, organization_id: @user.organization_id }, status: :ok
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end
  end