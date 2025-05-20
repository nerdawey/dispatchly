require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "valid order" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    assert order.valid?
  end

  test "invalid without customer_name" do
    order = Order.new(product_id: 1, quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:customer_name], "can't be blank"
  end

  test "invalid without product_id" do
    order = Order.new(customer_name: "Test Customer", quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:product_id], "can't be blank"
  end

  test "invalid without quantity" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:quantity], "can't be blank"
  end

  test "invalid without status" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:status], "can't be blank"
  end

  test "invalid without order_type" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, status: "pending", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:order_type], "can't be blank"
  end

  test "invalid without pickup_location_id" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, status: "pending", order_type: "standard", dropoff_location_id: 2, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:pickup_location_id], "can't be blank"
  end

  test "invalid without dropoff_location_id" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, warehouse_id: 1, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:dropoff_location_id], "can't be blank"
  end

  test "invalid without warehouse_id" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, deadline: Time.current)
    refute order.valid?
    assert_includes order.errors[:warehouse_id], "can't be blank"
  end

  test "invalid without deadline" do
    order = Order.new(customer_name: "Test Customer", product_id: 1, quantity: 1, status: "pending", order_type: "standard", pickup_location_id: 1, dropoff_location_id: 2, warehouse_id: 1)
    refute order.valid?
    assert_includes order.errors[:deadline], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
