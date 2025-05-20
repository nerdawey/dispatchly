require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "valid location" do
    organization = organizations(:one)
    
    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      latitude: 40.7128,
      longitude: -74.0060,
      organization: organization
    )
    assert location.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)
    
    location = Location.new(
      address: "123 Test St",
      latitude: 40.7128,
      longitude: -74.0060,
      organization: organization
    )
    refute location.valid?
    assert_includes location.errors[:name], "can't be blank"
  end

  test "invalid without address" do
    organization = organizations(:one)
    
    location = Location.new(
      name: "Test Location",
      latitude: 40.7128,
      longitude: -74.0060,
      organization: organization
    )
    refute location.valid?
    assert_includes location.errors[:address], "can't be blank"
  end

  test "invalid without latitude" do
    organization = organizations(:one)
    
    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      longitude: -74.0060,
      organization: organization
    )
    refute location.valid?
    assert_includes location.errors[:latitude], "can't be blank"
  end

  test "invalid without longitude" do
    organization = organizations(:one)
    
    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      latitude: 40.7128,
      organization: organization
    )
    refute location.valid?
    assert_includes location.errors[:longitude], "can't be blank"
  end

  test "invalid without organization_id" do
    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      latitude: 40.7128,
      longitude: -74.0060
    )
    refute location.valid?
    assert_includes location.errors[:organization_id], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
