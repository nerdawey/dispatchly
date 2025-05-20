require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    product = Product.new(name: "Test Product", description: "Test Description", price: 10.0, storage_temperature: "room")
    assert product.valid?
  end

  test "invalid without name" do
    product = Product.new(description: "Test Description", price: 10.0, storage_temperature: "room")
    refute product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "invalid without price" do
    product = Product.new(name: "Test Product", description: "Test Description", storage_temperature: "room")
    refute product.valid?
    assert_includes product.errors[:price], "can't be blank"
  end

  test "invalid without storage_temperature" do
    product = Product.new(name: "Test Product", description: "Test Description", price: 10.0)
    refute product.valid?
    assert_includes product.errors[:storage_temperature], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
