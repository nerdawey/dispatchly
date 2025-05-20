require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @headers = setup_auth_headers(@user)
  end

  test "should get index" do
    get "/api/v1/users", headers: @headers
    assert_response :success
    assert_not_nil JSON.parse(@response.body)
  end

  test "should get show" do
    get "/api/v1/users/#{@user.id}", headers: @headers
    assert_response :success
    assert_equal @user.id, JSON.parse(@response.body)["id"]
  end

  test "should create user" do
    assert_difference("User.count") do
      post "/api/v1/users", headers: @headers, params: {
        user: {
          email_address: "new@example.com",
          password: "password",
          role: "planner",
          organization_id: @user.organization_id
        }
      }
    end
    assert_response :created
  end

  test "should update user" do
    patch "/api/v1/users/#{@user.id}", headers: @headers, params: {
      user: { email_address: "updated@example.com" }
    }
    assert_response :success
    assert_equal "updated@example.com", JSON.parse(@response.body)["email_address"]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete "/api/v1/users/#{@user.id}", headers: @headers
    end
    assert_response :no_content
  end
end
