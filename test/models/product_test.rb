require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    organization = organizations(:one)
    
    product = Product.new(
      name: "Test Product",
      sku: "TEST-001",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    assert product.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)
    
    product = Product.new(
      sku: "TEST-001",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    refute product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "invalid without sku" do
    organization = organizations(:one)
    
    product = Product.new(
      name: "Test Product",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    refute product.valid?
    assert_includes product.errors[:sku], "can't be blank"
  end

  test "invalid without weight" do
    organization = organizations(:one)
    
    product = Product.new(
      name: "Test Product",
      sku: "TEST-001",
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    refute product.valid?
    assert_includes product.errors[:weight], "can't be blank"
  end

  test "invalid without volume" do
    organization = organizations(:one)
    
    product = Product.new(
      name: "Test Product",
      sku: "TEST-001",
      weight: 1.5,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    refute product.valid?
    assert_includes product.errors[:volume], "can't be blank"
  end

  test "invalid without required_temperature" do
    organization = organizations(:one)
    
    product = Product.new(
      name: "Test Product",
      sku: "TEST-001",
      weight: 1.5,
      volume: 2.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    refute product.valid?
    assert_includes product.errors[:required_temperature], "can't be blank"
  end

  test "invalid without organization_id" do
    product = Product.new(
      name: "Test Product",
      sku: "TEST-001",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      storage_temperature: "chilled"
    )
    refute product.valid?
    assert_includes product.errors[:organization_id], "can't be blank"
  end

  test "invalid without storage_temperature" do
    organization = organizations(:one)
    
    product = Product.new(
      name: "Test Product",
      sku: "TEST-001",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization
    )
    refute product.valid?
    assert_includes product.errors[:storage_temperature], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
