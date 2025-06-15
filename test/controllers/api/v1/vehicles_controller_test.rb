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
          plate_number: "ABC123",
          capacity_volume: 100.0,
          capacity_weight: 1000.0,
          organization_id: @user.organization_id,
          status: "active",
          model: "Toyota Hiace",
          year: 2020,
          box_type: "closed",
          last_maintenance_date: Date.current,
          freezing_available: true
        }
      }
    end
    assert_response :created
    response_data = JSON.parse(@response.body)
    assert_equal "ABC123", response_data["plate_number"]
    assert_equal @user.organization_id, response_data["organization_id"]
    assert_equal "active", response_data["status"]
    assert_equal "Toyota Hiace", response_data["model"]
    assert_equal 2020, response_data["year"]
    assert_equal "closed", response_data["box_type"]
    assert_equal true, response_data["freezing_available"]
  end

  test "should update vehicle" do
    patch "/api/v1/vehicles/#{@vehicle.id}", headers: @headers, params: {
      vehicle: {
        plate_number: "XYZ789",
        status: "active",
        model: "Mercedes Sprinter",
        year: 2021,
        box_type: "closed",
        last_maintenance_date: Date.current,
        freezing_available: false
      }
    }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal "XYZ789", response_data["plate_number"]
    assert_equal "active", response_data["status"]
    assert_equal "Mercedes Sprinter", response_data["model"]
    assert_equal 2021, response_data["year"]
    assert_equal "closed", response_data["box_type"]
    assert_equal false, response_data["freezing_available"]
    @vehicle.reload
    assert_equal "XYZ789", @vehicle.plate_number
    assert_equal "active", @vehicle.status
    assert_equal "Mercedes Sprinter", @vehicle.model
    assert_equal 2021, @vehicle.year
    assert_equal "closed", @vehicle.box_type
    assert_equal false, @vehicle.freezing_available
  end

  # test "should destroy vehicle" do
  #   assert_difference("Vehicle.count", -1) do
  #     delete "/api/v1/vehicles/#{@vehicle.id}", headers: @headers
  #   end
  #   assert_response :no_content
  # end
end
