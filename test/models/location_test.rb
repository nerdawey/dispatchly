require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "valid location with organization" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: "warehouse",
      city: "New York"
    )
    assert location.valid?
  end

  test "valid location without organization" do
    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: "warehouse",
      city: "New York"
    )
    assert location.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)

    location = Location.new(
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: "warehouse",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:name], "can't be blank"
  end

  test "invalid without address" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      organization: organization,
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: "warehouse",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:address], "can't be blank"
  end

  test "invalid without location_type" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      longitude: -74.0060,
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:location_type], "can't be blank"
  end

  test "invalid location_type value" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: "invalid",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:location_type], "is not included in the list"
  end

  test "invalid without city" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      longitude: -74.0060,
      location_type: "warehouse"
    )
    assert_not location.valid?
    assert_includes location.errors[:city], "can't be blank"
  end

  test "invalid without latitude" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      longitude: -74.0060,
      location_type: "warehouse",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:latitude], "can't be blank"
  end

  test "invalid without longitude" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      location_type: "warehouse",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:longitude], "can't be blank"
  end

  test "invalid latitude value" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: "invalid",
      longitude: -74.0060,
      location_type: "warehouse",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:latitude], "is not a number"
  end

  test "invalid longitude value" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization,
      latitude: 40.7128,
      longitude: "invalid",
      location_type: "warehouse",
      city: "New York"
    )
    assert_not location.valid?
    assert_includes location.errors[:longitude], "is not a number"
  end

  # test "the truth" do
  #   assert true
  # end
end
