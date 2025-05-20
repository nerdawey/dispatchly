require "test_helper"

class Api::V1::OrganizationsControllerTest < ActionController::TestCase
  setup do
    @organization = organizations(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test "should get show" do
    get :show, params: { id: @organization.id }
    assert_response :success
    assert_equal @organization.id, JSON.parse(@response.body)["id"]
  end

  test "should create organization" do
    assert_difference("Organization.count") do
      post :create, params: { organization: { name: "New Organization" } }
    end
    assert_response :created
  end

  test "should update organization" do
    patch :update, params: { id: @organization.id, organization: { name: "Updated Organization" } }
    assert_response :success
    assert_equal "Updated Organization", JSON.parse(@response.body)["name"]
  end

  test "should destroy organization" do
    assert_difference("Organization.count", -1) do
      delete :destroy, params: { id: @organization.id }
    end
    assert_response :no_content
  end
end
