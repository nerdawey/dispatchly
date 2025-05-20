# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include CanCan::Ability

  before_action :authenticate_request
  attr_reader :current_user

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  rescue_from JWT::DecodeError, with: :unauthorized_request
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def unauthorized_request
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
