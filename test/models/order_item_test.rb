require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  test "valid order_item" do
    order = orders(:one)
    product = products(:one)
    
    order_item = OrderItem.new(
      order: order,
      product: product,
      quantity: 2
    )
    assert order_item.valid?
  end

  test "invalid without order_id" do
    product = products(:one)
    
    order_item = OrderItem.new(
      product: product,
      quantity: 2
    )
    refute order_item.valid?
    assert_includes order_item.errors[:order_id], "can't be blank"
  end

  test "invalid without product_id" do
    order = orders(:one)
    
    order_item = OrderItem.new(
      order: order,
      quantity: 2
    )
    refute order_item.valid?
    assert_includes order_item.errors[:product_id], "can't be blank"
  end

  test "invalid without quantity" do
    order = orders(:one)
    product = products(:one)
    
    order_item = OrderItem.new(
      order: order,
      product: product
    )
    refute order_item.valid?
    assert_includes order_item.errors[:quantity], "can't be blank"
  end

  test "invalid with negative quantity" do
    order = orders(:one)
    product = products(:one)
    
    order_item = OrderItem.new(
      order: order,
      product: product,
      quantity: -1
    )
    refute order_item.valid?
    assert_includes order_item.errors[:quantity], "must be greater than 0"
  end

  # test "the truth" do
  #   assert true
  # end
end
