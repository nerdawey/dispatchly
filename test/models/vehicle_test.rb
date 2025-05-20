require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "valid vehicle" do
    organization = organizations(:one)
    current_location = locations(:one)
    
    vehicle = Vehicle.new(
      name: "Test Vehicle",
      organization: organization,
      capacity_volume: 1000,
      capacity_weight: 2000,
      current_location: current_location
    )
    assert vehicle.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)
    current_location = locations(:one)
    
    vehicle = Vehicle.new(
      organization: organization,
      capacity_volume: 1000,
      capacity_weight: 2000,
      current_location: current_location
    )
    refute vehicle.valid?
    assert_includes vehicle.errors[:name], "can't be blank"
  end

  test "invalid without organization_id" do
    current_location = locations(:one)
    
    vehicle = Vehicle.new(
      name: "Test Vehicle",
      capacity_volume: 1000,
      capacity_weight: 2000,
      current_location: current_location
    )
    refute vehicle.valid?
    assert_includes vehicle.errors[:organization_id], "can't be blank"
  end

  test "invalid without capacity_volume" do
    organization = organizations(:one)
    current_location = locations(:one)
    
    vehicle = Vehicle.new(
      name: "Test Vehicle",
      organization: organization,
      capacity_weight: 2000,
      current_location: current_location
    )
    refute vehicle.valid?
    assert_includes vehicle.errors[:capacity_volume], "can't be blank"
  end

  test "invalid without capacity_weight" do
    organization = organizations(:one)
    current_location = locations(:one)
    
    vehicle = Vehicle.new(
      name: "Test Vehicle",
      organization: organization,
      capacity_volume: 1000,
      current_location: current_location
    )
    refute vehicle.valid?
    assert_includes vehicle.errors[:capacity_weight], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
