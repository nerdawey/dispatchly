require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @headers = setup_auth_headers(@user)
  end

  test "should return unauthorized without token" do
    get "/api/v1/products"
    assert_response :unauthorized
    assert_includes @response.body, "Unauthorized"
  end

  test "should return unauthorized with invalid token" do
    get "/api/v1/products", headers: { "Authorization" => "Bearer invalidtoken" }
    assert_response :unauthorized
    assert_includes @response.body, "Unauthorized"
  end

  test "should allow access with valid token" do
    get "/api/v1/products", headers: @headers
    assert_response :success
  end

  test "should return forbidden on CanCan::AccessDenied" do
    # Create a user with no permissions
    user = users(:one)
    user.update!(role: :dispatcher)
    headers = setup_auth_headers(user)

    # Try to access a restricted endpoint
    get "/api/v1/organizations", headers: headers
    assert_response :forbidden
  end
end
