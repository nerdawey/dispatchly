# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :current_user

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  rescue_from JWT::DecodeError, with: :unauthorized_request
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_request

  private

  def authenticate_user!
    header = request.headers['Authorization']
    return unauthorized_request unless header.present?

    token = header.split(' ').last
    decoded = JsonWebToken.decode(token)
    return unauthorized_request unless decoded.present?

    @current_user = User.find_by(id: decoded[:user_id])
    return unauthorized_request unless @current_user
  end

  def unauthorized_request
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
