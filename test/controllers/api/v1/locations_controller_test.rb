require "test_helper"

class Api::V1::LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:one)
    @user = users(:one)  # Using org_admin user
    @headers = setup_auth_headers(@user)
  end

  test "should get index" do
    get "/api/v1/locations", headers: @headers
    assert_response :success
    assert_not_nil JSON.parse(@response.body)["locations"]
  end

  test "should get show" do
    get "/api/v1/locations/#{@location.id}", headers: @headers
    assert_response :success
    assert_equal @location.id, JSON.parse(@response.body)["id"]
  end

  test "should create location" do
    assert_difference("Location.count") do
      post "/api/v1/locations", headers: @headers, params: {
        location: {
          name: "New Location",
          address: "789 Test Blvd",
          latitude: 40.7128,
          longitude: -74.0060,
          organization_id: @user.organization_id
        }
      }
    end
    assert_response :created
    response_data = JSON.parse(@response.body)
    assert_equal "New Location", response_data["name"]
    assert_equal "789 Test Blvd", response_data["address"]
    assert_equal @user.organization_id, response_data["organization_id"]
  end

  test "should update location" do
    patch "/api/v1/locations/#{@location.id}", headers: @headers, params: {
      location: { name: "Updated Location" }
    }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal "Updated Location", response_data["name"]
    @location.reload
    assert_equal "Updated Location", @location.name
  end

  test "should destroy location" do
    assert_no_difference("Location.count") do
      delete "/api/v1/locations/#{@location.id}", headers: @headers
    end
    assert_response :method_not_allowed
    response_data = JSON.parse(@response.body)
    assert_equal "Deleting locations is not allowed.", response_data["error"]
  end
end
