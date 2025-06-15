require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test "valid vehicle" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert vehicle.valid?
  end

  test "invalid without plate_number" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:plate_number], "can't be blank"
  end

  test "invalid without capacity_volume" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:capacity_volume], "can't be blank"
  end

  test "invalid without capacity_weight" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:capacity_weight], "can't be blank"
  end

  test "invalid without status" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:status], "can't be blank"
  end

  test "invalid without model" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:model], "can't be blank"
  end

  test "invalid without year" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:year], "can't be blank"
  end

  test "invalid without box_type" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:box_type], "can't be blank"
  end

  test "invalid without last_maintenance_date" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:last_maintenance_date], "can't be blank"
  end

  test "invalid without organization" do
    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:organization], "must exist"
  end

  test "invalid freezing_available for non-closed box" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "open",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_not vehicle.valid?
    assert_includes vehicle.errors[:freezing_available], "can only be true if box_type is closed"
  end

  test "valid freezing_available for closed box" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert vehicle.valid?
  end

  test "valid non-freezing for any box type" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "open",
      last_maintenance_date: Date.today,
      freezing_available: false,
      organization: organization
    )
    assert vehicle.valid?
  end

  test "capacity returns minimum of volume and weight" do
    organization = organizations(:one)

    vehicle = Vehicle.new(
      plate_number: "ABC123",
      capacity_volume: 1000,
      capacity_weight: 2000,
      status: "active",
      model: "Test Model",
      year: 2023,
      box_type: "closed",
      last_maintenance_date: Date.today,
      freezing_available: true,
      organization: organization
    )
    assert_equal 1000, vehicle.capacity

    vehicle.capacity_volume = 3000
    assert_equal 2000, vehicle.capacity
  end

  test "available? returns true for active vehicle with no active trips" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    vehicle.update!(status: "active")
    vehicle.trips.where(status: ["in_progress", "scheduled"]).destroy_all

    assert vehicle.available?
  end

  test "available? returns false for inactive vehicle" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    vehicle.update!(status: "inactive")
    vehicle.trips.where(status: ["in_progress", "scheduled"]).destroy_all

    assert_not vehicle.available?
  end
end
