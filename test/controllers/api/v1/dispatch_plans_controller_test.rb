require "test_helper"

class Api::V1::DispatchPlansControllerTest < ActionController::TestCase
  setup do
    @dispatch_plan = dispatch_plans(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dispatch_plans)
  end

  test "should get show" do
    get :show, params: { id: @dispatch_plan.id }
    assert_response :success
    assert_equal @dispatch_plan.id, JSON.parse(@response.body)["id"]
  end

  test "should create dispatch_plan" do
    assert_difference("DispatchPlan.count") do
      post :create, params: { dispatch_plan: { name: "New Dispatch Plan", status: "pending", scheduled_date: Time.current } }
    end
    assert_response :created
  end

  test "should update dispatch_plan" do
    patch :update, params: { id: @dispatch_plan.id, dispatch_plan: { name: "Updated Dispatch Plan" } }
    assert_response :success
    assert_equal "Updated Dispatch Plan", JSON.parse(@response.body)["name"]
  end

  test "should destroy dispatch_plan" do
    assert_difference("DispatchPlan.count", -1) do
      delete :destroy, params: { id: @dispatch_plan.id }
    end
    assert_response :no_content
  end
end
