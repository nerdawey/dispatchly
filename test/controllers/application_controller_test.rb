require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  class DummyController < ApplicationController
    def index
      render json: { message: 'ok' }
    end
  end

  tests DummyController

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw { get 'index' => 'application_controller_test/dummy#index' }
    @user = User.create!(email_address: 'test@example.com', password: 'password', role: :super_admin)
    @token = JsonWebToken.encode(user_id: @user.id)
  end

  test 'should return unauthorized without token' do
    get :index
    assert_response :unauthorized
    assert_includes @response.body, 'Unauthorized'
  end

  test 'should return unauthorized with invalid token' do
    @request.headers['Authorization'] = 'Bearer invalidtoken'
    get :index
    assert_response :unauthorized
    assert_includes @response.body, 'Unauthorized'
  end

  test 'should allow access with valid token' do
    @request.headers['Authorization'] = "Bearer #{@token}"
    get :index
    assert_response :success
    assert_includes @response.body, 'ok'
  end

  test 'should return forbidden on CanCan::AccessDenied' do
    DummyController.any_instance.stubs(:index).raises(CanCan::AccessDenied.new('forbidden'))
    @request.headers['Authorization'] = "Bearer #{@token}"
    get :index
    assert_response :forbidden
    assert_includes @response.body, 'forbidden'
  end
end 