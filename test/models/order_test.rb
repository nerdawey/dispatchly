require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @pickup_location = locations(:one)
    @delivery_location = locations(:two)
    @product = products(:one)
  end

  test "valid order" do
    order = build_valid_order
    assert order.valid?
  end

  test "invalid without order_number" do
    order = build_valid_order(order_number: nil)
    assert_not order.valid?
    assert_includes order.errors[:order_number], "can't be blank"
  end

  test "invalid without order_type" do
    order = build_valid_order(order_type: nil)
    assert_not order.valid?
    assert_includes order.errors[:order_type], "can't be blank"
  end

  test "invalid without status" do
    order = build_valid_order(status: nil)
    assert_not order.valid?
    assert_includes order.errors[:status], "can't be blank"
  end

  test "invalid without pickup_time_window_start" do
    order = build_valid_order(pickup_time_window_start: nil)
    assert_not order.valid?
    assert_includes order.errors[:pickup_time_window_start], "can't be blank"
  end

  test "invalid without pickup_time_window_end" do
    order = build_valid_order(pickup_time_window_end: nil)
    assert_not order.valid?
    assert_includes order.errors[:pickup_time_window_end], "can't be blank"
  end

  test "invalid without delivery_deadline" do
    order = build_valid_order(delivery_deadline: nil)
    assert_not order.valid?
    assert_includes order.errors[:delivery_deadline], "can't be blank"
  end

  test "invalid without organization" do
    order = build_valid_order(organization: nil)
    assert_not order.valid?
    assert_includes order.errors[:organization], "must exist"
  end

  test "invalid without pickup_location" do
    order = build_valid_order(pickup_location: nil)
    assert_not order.valid?
    assert_includes order.errors[:pickup_location], "must exist"
  end

  test "invalid without delivery_location" do
    order = build_valid_order(delivery_location: nil)
    assert_not order.valid?
    assert_includes order.errors[:delivery_location], "must exist"
  end

  test "valid without trip" do
    order = build_valid_order(trip: nil)
    assert order.valid?
  end

  private

  def build_valid_order(attributes = {})
    order = Order.new(
      {
        order_number: "ORD-001",
        order_type: "outbound",
        status: "pending",
        pickup_time_window_start: Time.current,
        pickup_time_window_end: 2.hours.from_now,
        delivery_deadline: 1.day.from_now,
        organization: @organization,
        pickup_location: @pickup_location,
        delivery_location: @delivery_location
      }.merge(attributes)
    )

    order.order_items.build(
      product: @product,
      quantity: 1
    )

    order
  end
end
