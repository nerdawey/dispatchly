require "test_helper"

class Api::V1::VehiclesControllerTest < ActionController::TestCase
  setup do
    @vehicle = vehicles(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicles)
  end

  test "should get show" do
    get :show, params: { id: @vehicle.id }
    assert_response :success
    assert_equal @vehicle.id, JSON.parse(@response.body)["id"]
  end

  test "should create vehicle" do
    assert_difference("Vehicle.count") do
      post :create, params: { vehicle: { capacity: 200, organization_id: 1 } }
    end
    assert_response :created
  end

  test "should update vehicle" do
    patch :update, params: { id: @vehicle.id, vehicle: { capacity: 300 } }
    assert_response :success
    assert_equal 300, JSON.parse(@response.body)["capacity"]
  end

  test "should destroy vehicle" do
    assert_difference("Vehicle.count", -1) do
      delete :destroy, params: { id: @vehicle.id }
    end
    assert_response :no_content
  end
end
