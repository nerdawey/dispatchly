require "test_helper"

class Api::V1::UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get show" do
    get :show, params: { id: @user.id }
    assert_response :success
    assert_equal @user.id, JSON.parse(@response.body)["id"]
  end

  test "should create user" do
    assert_difference("User.count") do
      post :create, params: { user: { email_address: "new@example.com", password: "password", role: :org_admin, organization_id: 1 } }
    end
    assert_response :created
  end

  test "should update user" do
    patch :update, params: { id: @user.id, user: { email_address: "updated@example.com" } }
    assert_response :success
    assert_equal "updated@example.com", JSON.parse(@response.body)["email_address"]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete :destroy, params: { id: @user.id }
    end
    assert_response :no_content
  end
end
