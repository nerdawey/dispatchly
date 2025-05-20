require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "valid order" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    assert order.valid?
  end

  test "invalid without order_number" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:order_number], "can't be blank"
  end

  test "invalid without organization_id" do
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:organization_id], "can't be blank"
  end

  test "invalid without pickup_location_id" do
    organization = organizations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:pickup_location_id], "can't be blank"
  end

  test "invalid without delivery_location_id" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:delivery_location_id], "can't be blank"
  end

  test "invalid without pickup_time_window_start" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:pickup_time_window_start], "can't be blank"
  end

  test "invalid without pickup_time_window_end" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      delivery_deadline: Time.current + 2.hours,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:pickup_time_window_end], "can't be blank"
  end

  test "invalid without delivery_deadline" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      status: "pending",
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:delivery_deadline], "can't be blank"
  end

  test "invalid without status" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      order_type: "outbound"
    )
    refute order.valid?
    assert_includes order.errors[:status], "can't be blank"
  end

  test "invalid without order_type" do
    organization = organizations(:one)
    pickup_location = locations(:one)
    delivery_location = locations(:two)
    
    order = Order.new(
      order_number: "ORD-001",
      organization: organization,
      pickup_location: pickup_location,
      delivery_location: delivery_location,
      pickup_time_window_start: Time.current,
      pickup_time_window_end: Time.current + 1.hour,
      delivery_deadline: Time.current + 2.hours,
      status: "pending"
    )
    refute order.valid?
    assert_includes order.errors[:order_type], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
