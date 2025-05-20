require 'test_helper'

class Api::V1::LocationsControllerTest < ActionController::TestCase
  setup do
    @location = locations(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers['Authorization'] = "Bearer #{@token}"
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test 'should get show' do
    get :show, params: { id: @location.id }
    assert_response :success
    assert_equal @location.id, JSON.parse(@response.body)['id']
  end

  test 'should create location' do
    assert_difference('Location.count') do
      post :create, params: { location: { address: '456 Test Ave', latitude: 40.7128, longitude: -74.0060 } }
    end
    assert_response :created
  end

  test 'should update location' do
    patch :update, params: { id: @location.id, location: { address: 'Updated Address' } }
    assert_response :success
    assert_equal 'Updated Address', JSON.parse(@response.body)['address']
  end

  test 'should destroy location' do
    assert_difference('Location.count', -1) do
      delete :destroy, params: { id: @location.id }
    end
    assert_response :no_content
  end
end
