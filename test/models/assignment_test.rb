require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  test "valid assignment" do
    trip = trips(:one)
    vehicle = vehicles(:one)
    
    assignment = Assignment.new(
      trip: trip,
      vehicle: vehicle
    )
    assert assignment.valid?
  end

  test "invalid without trip_id" do
    vehicle = vehicles(:one)
    
    assignment = Assignment.new(
      vehicle: vehicle
    )
    refute assignment.valid?
    assert_includes assignment.errors[:trip_id], "can't be blank"
  end

  test "invalid without vehicle_id" do
    trip = trips(:one)
    
    assignment = Assignment.new(
      trip: trip
    )
    refute assignment.valid?
    assert_includes assignment.errors[:vehicle_id], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
