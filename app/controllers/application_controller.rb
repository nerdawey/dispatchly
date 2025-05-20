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
    token = header.split(' ').last if header.present?
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded && decoded[:user_id]
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  rescue
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def unauthorized_request
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
