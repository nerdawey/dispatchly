# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include CanCan::ControllerAdditions

  before_action :authenticate_request
  attr_reader :current_user

  rescue_from CanCan::AccessDenied do |e|
    render json: { error: e.message }, status: :forbidden
  end

  rescue_from JWT::DecodeError, with: :unauthorized_request
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    return unauthorized_request unless header

    token = header.split(' ').last
    begin
      @decoded = JsonWebToken.decode(token)
      return unauthorized_request unless @decoded && @decoded['user_id']
      @current_user = User.find(@decoded['user_id'])
      if Rails.env.test?
        Rails.logger.debug { "[AUTH DEBUG] Decoded JWT: \\#{@decoded.inspect}, Current User ID: \\#{@current_user&.id}" }
        Rails.logger.debug { "[AUTH DEBUG] Decoded JWT: \\#{@decoded.inspect}, Current User ID: \\#{@current_user&.id}" }
      end
    rescue ActiveRecord::RecordNotFound => e
      unauthorized_request
    rescue JWT::DecodeError => e
      unauthorized_request
    end
  end

  def unauthorized_request
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  public

  def authorize!(*args)
    if Rails.env.test?
      Rails.logger.debug { "[AUTHORIZE DEBUG] current_ability: #{current_ability.inspect}, @product: #{@product.inspect}, product_org_id: #{@product&.organization_id}" }
    end
    super
  end
end
