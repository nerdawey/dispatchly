require "test_helper"

class Api::V1::VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle = vehicles(:one)
    @user = users(:one)
    @headers = setup_auth_headers(@user)
  end

  test "should get index" do
    get "/api/v1/vehicles", headers: @headers
    assert_response :success
    assert_not_nil JSON.parse(@response.body)
  end

  test "should get show" do
    get "/api/v1/vehicles/#{@vehicle.id}", headers: @headers
    assert_response :success
    assert_equal @vehicle.id, JSON.parse(@response.body)["id"]
  end

  test "should create vehicle" do
    assert_difference("Vehicle.count") do
      post "/api/v1/vehicles", headers: @headers, params: {
        vehicle: {
          name: "New Vehicle",
          plate_number: "ABC123",
          capacity_volume: 100.0,
          capacity_weight: 1000.0,
          min_temp: -10,
          max_temp: 10,
          organization_id: @user.organization_id,
          current_location_id: locations(:one).id,
          status: "active",
          cost_per_km: 2.5
        }
      }
    end
    assert_response :created
  end

  test "should update vehicle" do
    patch "/api/v1/vehicles/#{@vehicle.id}", headers: @headers, params: {
      vehicle: {
        name: "Updated Vehicle",
        plate_number: "XYZ789",
        min_temp: -5,
        max_temp: 5,
        status: "active",
        cost_per_km: 3.0
      }
    }
    assert_response :success
    assert_equal "Updated Vehicle", JSON.parse(@response.body)["name"]
  end

  # test "should destroy vehicle" do
  #   assert_difference("Vehicle.count", -1) do
  #     delete "/api/v1/vehicles/#{@vehicle.id}", headers: @headers
  #   end
  #   assert_response :no_content
  # end
end
