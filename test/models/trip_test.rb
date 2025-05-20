require "test_helper"

class TripTest < ActiveSupport::TestCase
  test "valid trip" do
    organization = organizations(:one)
    vehicle = vehicles(:one)

    trip = Trip.new(
      name: "Test Trip",
      status: "scheduled",
      scheduled_date: Time.zone.today,
      start_time: Time.current,
      end_time: 2.hours.from_now,
      organization: organization,
      vehicle: vehicle
    )
    assert trip.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)
    vehicle = vehicles(:one)

    trip = Trip.new(
      status: "scheduled",
      scheduled_date: Time.zone.today,
      start_time: Time.current,
      end_time: 2.hours.from_now,
      organization: organization,
      vehicle: vehicle
    )
    assert_not trip.valid?
    assert_includes trip.errors[:name], "can't be blank"
  end

  test "invalid without status" do
    organization = organizations(:one)
    vehicle = vehicles(:one)

    trip = Trip.new(
      name: "Test Trip",
      scheduled_date: Time.zone.today,
      start_time: Time.current,
      end_time: 2.hours.from_now,
      organization: organization,
      vehicle: vehicle
    )
    assert_not trip.valid?
    assert_includes trip.errors[:status], "can't be blank"
  end

  test "invalid without scheduled_date" do
    organization = organizations(:one)
    vehicle = vehicles(:one)

    trip = Trip.new(
      name: "Test Trip",
      status: "scheduled",
      start_time: Time.current,
      end_time: 2.hours.from_now,
      organization: organization,
      vehicle: vehicle
    )
    assert_not trip.valid?
    assert_includes trip.errors[:scheduled_date], "can't be blank"
  end

  test "invalid without start_time" do
    organization = organizations(:one)
    vehicle = vehicles(:one)

    trip = Trip.new(
      name: "Test Trip",
      status: "scheduled",
      scheduled_date: Time.zone.today,
      end_time: 2.hours.from_now,
      organization: organization,
      vehicle: vehicle
    )
    assert_not trip.valid?
    assert_includes trip.errors[:start_time], "can't be blank"
  end

  test "invalid without end_time" do
    organization = organizations(:one)
    vehicle = vehicles(:one)

    trip = Trip.new(
      name: "Test Trip",
      status: "scheduled",
      scheduled_date: Time.zone.today,
      start_time: Time.current,
      organization: organization,
      vehicle: vehicle
    )
    assert_not trip.valid?
    assert_includes trip.errors[:end_time], "can't be blank"
  end

  test "invalid without organization" do
    vehicle = vehicles(:one)

    trip = Trip.new(
      name: "Test Trip",
      status: "scheduled",
      scheduled_date: Time.zone.today,
      start_time: Time.current,
      end_time: 2.hours.from_now,
      vehicle: vehicle
    )
    assert_not trip.valid?
    assert_includes trip.errors[:organization], "must exist"
  end

  test "invalid without vehicle" do
    organization = organizations(:one)

    trip = Trip.new(
      name: "Test Trip",
      status: "scheduled",
      scheduled_date: Time.zone.today,
      start_time: Time.current,
      end_time: 2.hours.from_now,
      organization: organization
    )
    assert_not trip.valid?
    assert_includes trip.errors[:vehicle], "must exist"
  end

  # test "the truth" do
  #   assert true
  # end
end
