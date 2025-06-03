require "test_helper"

class Api::V1::OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
    @user = users(:one)
    @headers = setup_auth_headers(@user)
  end

  test "should get index" do
    get "/api/v1/organizations", headers: @headers
    assert_response :success
    assert_not_nil JSON.parse(@response.body)
  end

  test "should get show" do
    get "/api/v1/organizations/#{@organization.id}", headers: @headers
    assert_response :success
    assert_equal @organization.id, JSON.parse(@response.body)["id"]
  end

  test "should create organization" do
    assert_difference("Organization.count") do
      post "/api/v1/organizations", headers: @headers, params: {
        organization: {
          name: "New Organization",
          address: "789 Test Blvd",
          contact_email: "contact@neworg.com",
          contact_phone: "555-123-4567",
          subscription_tier: "standard",
          status: "active"
        }
      }
    end
    assert_response :created
  end

  test "should update organization" do
    patch "/api/v1/organizations/#{@organization.id}", headers: @headers, params: {
      organization: { name: "Updated Organization" }
    }
    assert_response :success
    assert_equal "Updated Organization", JSON.parse(@response.body)["name"]
  end

  # test "should destroy organization" do
  #   assert_difference("Organization.count", -1) do
  #     delete "/api/v1/organizations/#{@organization.id}", headers: @headers
  #   end
  #   assert_response :no_content
  # end
end
