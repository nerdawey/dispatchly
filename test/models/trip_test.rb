require "test_helper"

class TripTest < ActiveSupport::TestCase
  test "valid trip" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      organization: organization,
      vehicle: vehicle,
      status: "pending",
      scheduled_date: Time.current,
      start_time: Time.current,
      end_time: Time.current + 2.hours
    )
    assert trip.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      organization: organization,
      vehicle: vehicle,
      status: "pending",
      scheduled_date: Time.current,
      start_time: Time.current,
      end_time: Time.current + 2.hours
    )
    refute trip.valid?
    assert_includes trip.errors[:name], "can't be blank"
  end

  test "invalid without organization_id" do
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      vehicle: vehicle,
      status: "pending",
      scheduled_date: Time.current,
      start_time: Time.current,
      end_time: Time.current + 2.hours
    )
    refute trip.valid?
    assert_includes trip.errors[:organization_id], "can't be blank"
  end

  test "invalid without vehicle_id" do
    organization = organizations(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      organization: organization,
      status: "pending",
      scheduled_date: Time.current,
      start_time: Time.current,
      end_time: Time.current + 2.hours
    )
    refute trip.valid?
    assert_includes trip.errors[:vehicle_id], "can't be blank"
  end

  test "invalid without status" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      organization: organization,
      vehicle: vehicle,
      scheduled_date: Time.current,
      start_time: Time.current,
      end_time: Time.current + 2.hours
    )
    refute trip.valid?
    assert_includes trip.errors[:status], "can't be blank"
  end

  test "invalid without scheduled_date" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      organization: organization,
      vehicle: vehicle,
      status: "pending",
      start_time: Time.current,
      end_time: Time.current + 2.hours
    )
    refute trip.valid?
    assert_includes trip.errors[:scheduled_date], "can't be blank"
  end

  test "invalid without start_time" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      organization: organization,
      vehicle: vehicle,
      status: "pending",
      scheduled_date: Time.current,
      end_time: Time.current + 2.hours
    )
    refute trip.valid?
    assert_includes trip.errors[:start_time], "can't be blank"
  end

  test "invalid without end_time" do
    organization = organizations(:one)
    vehicle = vehicles(:one)
    
    trip = Trip.new(
      name: "Test Trip",
      organization: organization,
      vehicle: vehicle,
      status: "pending",
      scheduled_date: Time.current,
      start_time: Time.current
    )
    refute trip.valid?
    assert_includes trip.errors[:end_time], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
