require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @user = users(:one)  # Using org_admin user
    @headers = setup_auth_headers(@user)
  end

  test "should get index" do
    get "/api/v1/orders", headers: @headers
    assert_response :success
    assert_not_nil JSON.parse(@response.body)["orders"]
  end

  test "should get show" do
    get "/api/v1/orders/#{@order.id}", headers: @headers
    assert_response :success
    assert_equal @order.id, JSON.parse(@response.body)["id"]
  end

  test "should create order" do
    assert_difference("Order.count") do
      post "/api/v1/orders", headers: @headers, params: {
        order: {
          order_number: "ORD-003",
          organization_id: @user.organization_id,
          pickup_location_id: locations(:one).id,
          delivery_location_id: locations(:two).id,
          pickup_time_window_start: Time.current,
          pickup_time_window_end: Time.current + 1.hour,
          delivery_deadline: Time.current + 2.hours,
          status: "pending",
          order_type: "outbound"
        }
      }
    end
    assert_response :created
    response_data = JSON.parse(@response.body)
    assert_equal "ORD-003", response_data["order_number"]
    assert_equal @user.organization_id, response_data["organization_id"]
  end

  test "should update order" do
    patch "/api/v1/orders/#{@order.id}", headers: @headers, params: {
      order: { status: "completed" }
    }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal "completed", response_data["status"]
    @order.reload
    assert_equal "completed", @order.status
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete "/api/v1/orders/#{@order.id}", headers: @headers
    end
    assert_response :no_content
    assert_raises(ActiveRecord::RecordNotFound) do
      @order.reload
    end
  end
end
