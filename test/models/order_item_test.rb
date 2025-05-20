require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  test 'valid order_item' do
    order_item = OrderItem.new(order_id: 1, product_id: 1, quantity: 1)
    assert order_item.valid?
  end

  test 'invalid without order_id' do
    order_item = OrderItem.new(product_id: 1, quantity: 1)
    refute order_item.valid?
    assert_includes order_item.errors[:order_id], "can't be blank"
  end

  test 'invalid without product_id' do
    order_item = OrderItem.new(order_id: 1, quantity: 1)
    refute order_item.valid?
    assert_includes order_item.errors[:product_id], "can't be blank"
  end

  test 'invalid without quantity' do
    order_item = OrderItem.new(order_id: 1, product_id: 1)
    refute order_item.valid?
    assert_includes order_item.errors[:quantity], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
