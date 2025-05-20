require "test_helper"

class Api::V1::OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
    @user = users(:one)
    @token = JsonWebToken.encode(user_id: @user.id)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get show" do
    get :show, params: { id: @order.id }
    assert_response :success
    assert_equal @order.id, JSON.parse(@response.body)["id"]
  end

  test "should create order" do
    assert_difference("Order.count") do
      post :create, params: { order: { customer_name: "New Customer", product_id: 1, quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current } }
    end
    assert_response :created
  end

  test "should update order" do
    patch :update, params: { id: @order.id, order: { customer_name: "Updated Customer" } }
    assert_response :success
    assert_equal "Updated Customer", JSON.parse(@response.body)["customer_name"]
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete :destroy, params: { id: @order.id }
    end
    assert_response :no_content
  end
end
