require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    organization = organizations(:one)

    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    puts product.errors.full_messages unless product.valid?
    assert product.valid?
  end

  test "invalid without sku" do
    organization = organizations(:one)

    product = Product.new(
      weight: 1.5,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:sku], "can't be blank"
  end

  test "invalid without weight" do
    organization = organizations(:one)

    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:weight], "can't be blank"
  end

  test "invalid without organization" do
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    puts product.errors.full_messages unless product.valid?
    assert_not product.valid?
    assert_includes product.errors[:organization], "must exist"
  end

  test "valid storage temperature values" do
    organization = organizations(:one)

    # Test ambient
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      organization: organization,
      storage_temperature: "ambient",
      number_of_boxes: 100
    )
    assert product.valid?

    # Test chilled
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      organization: organization,
      storage_temperature: "chilled",
      number_of_boxes: 100
    )
    assert product.valid?

    # Test frozen
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    assert product.valid?

    # Test invalid value
    assert_raises(ArgumentError) do
      Product.new(
        sku: "TEST-#{Time.current.to_i}",
        weight: 1.5,
        organization: organization,
        storage_temperature: "invalid",
        number_of_boxes: 100
      )
    end
  end

  test "invalid weight values" do
    organization = organizations(:one)

    # Test zero weight
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 0,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    assert_not product.valid?
    assert_includes product.errors[:weight], "must be greater than 0"

    # Test negative weight
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: -1.5,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100
    )
    assert_not product.valid?
    assert_includes product.errors[:weight], "must be greater than 0"
  end

  test "optional dimensions" do
    organization = organizations(:one)

    # Test valid dimensions
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100,
      length: 10,
      width: 5,
      height: 2
    )
    assert product.valid?

    # Test invalid dimensions
    product = Product.new(
      sku: "TEST-#{Time.current.to_i}",
      weight: 1.5,
      organization: organization,
      storage_temperature: "frozen",
      number_of_boxes: 100,
      length: 0,
      width: -1,
      height: 0
    )
    assert_not product.valid?
    assert_includes product.errors[:length], "must be greater than 0"
    assert_includes product.errors[:width], "must be greater than 0"
    assert_includes product.errors[:height], "must be greater than 0"
  end

  # test "the truth" do
  #   assert true
  # end
end
