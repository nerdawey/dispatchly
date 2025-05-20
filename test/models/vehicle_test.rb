require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "valid vehicle" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert vehicle.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:name], "can't be blank"
  end

  test "invalid without plate_number" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:plate_number], "can't be blank"
  end

  test "invalid without capacity_volume" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:capacity_volume], "can't be blank"
  end

  test "invalid without capacity_weight" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:capacity_weight], "can't be blank"
  end

  test "invalid without min_temp" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:min_temp], "can't be blank"
  end

  test "invalid without max_temp" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      organization: organization,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:max_temp], "can't be blank"
  end

  test "invalid without organization" do
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      current_location: location,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:organization], "must exist"
  end

  test "invalid without current_location" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      status: "available",
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:current_location], "must exist"
  end

  test "invalid without status" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      cost_per_km: 2.5
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:status], "can't be blank"
  end

  test "invalid without cost_per_km" do
    organization = organizations(:one)
    location = locations(:one)

    vehicle = Vehicle.new(
      name: "Test Vehicle",
      plate_number: "ABC123",
      capacity_volume: 100.0,
      capacity_weight: 1000.0,
      min_temp: -20,
      max_temp: 20,
      organization: organization,
      current_location: location,
      status: "available"
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:cost_per_km], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
