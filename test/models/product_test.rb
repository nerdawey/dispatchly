require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    organization = organizations(:one)

    product = Product.new(
      name: "Test Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    puts product.errors.full_messages unless product.valid?
    assert product.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)

    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
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
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:sku], "can't be blank"
  end

  test "invalid without weight" do
    organization = organizations(:one)

    product = Product.new(
      name: "Test Product",
      sku: "TEST-#{Time.current.to_i}",
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:weight], "can't be blank"
  end

  test "invalid without volume" do
    organization = organizations(:one)

    product = Product.new(
      name: "Test Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:volume], "can't be blank"
  end

  test "invalid without required_temperature" do
    organization = organizations(:one)

    product = Product.new(
      name: "Test Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:required_temperature], "can't be blank"
  end

  test "invalid without organization" do
    product = Product.new(
      name: "Test Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      storage_temperature: "chilled"
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:organization], "must exist"
  end

  test "valid storage temperature values" do
    organization = organizations(:one)

    # Test ambient
    product = Product.new(
      name: "Ambient Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "ambient"
    )
    assert product.valid?

    # Test chilled
    product = Product.new(
      name: "Chilled Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "chilled"
    )
    assert product.valid?

    # Test frozen
    product = Product.new(
      name: "Frozen Product",
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      volume: 2.0,
      required_temperature: 4.0,
      organization: organization,
      storage_temperature: "frozen"
    )
    assert product.valid?

    # Test invalid value
    assert_raises(ArgumentError) do
      Product.new(
        name: "Invalid Product",
        sku: "TEST-#{Time.current.to_i}",
        weight: 1.5,
        volume: 2.0,
        required_temperature: 4.0,
        organization: organization,
        storage_temperature: "invalid"
      )
    end
  end

  # test "the truth" do
  #   assert true
  # end
end
