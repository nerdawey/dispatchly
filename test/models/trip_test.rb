require "test_helper"

class TripTest < ActiveSupport::TestCase
  test "valid trip" do
    trip = Trip.new(name: "Test Trip", vehicle_id: 1, status: "pending", scheduled_date: Time.current)
    assert trip.valid?
  end

  test "invalid without name" do
    trip = Trip.new(vehicle_id: 1, status: "pending", scheduled_date: Time.current)
    refute trip.valid?
    assert_includes trip.errors[:name], "can't be blank"
  end

  test "invalid without vehicle_id" do
    trip = Trip.new(name: "Test Trip", status: "pending", scheduled_date: Time.current)
    refute trip.valid?
    assert_includes trip.errors[:vehicle_id], "can't be blank"
  end

  test "invalid without status" do
    trip = Trip.new(name: "Test Trip", vehicle_id: 1, scheduled_date: Time.current)
    refute trip.valid?
    assert_includes trip.errors[:status], "can't be blank"
  end

  test "invalid without scheduled_date" do
    trip = Trip.new(name: "Test Trip", vehicle_id: 1, status: "pending")
    refute trip.valid?
    assert_includes trip.errors[:scheduled_date], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
