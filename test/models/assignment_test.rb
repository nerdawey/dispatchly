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

  test "invalid without trip" do
    vehicle = vehicles(:one)

    assignment = Assignment.new(
      vehicle: vehicle
    )
    assert_not assignment.valid?
    assert_includes assignment.errors[:trip], "must exist"
  end

  test "invalid without vehicle" do
    trip = trips(:one)

    assignment = Assignment.new(
      trip: trip
    )
    assert_not assignment.valid?
    assert_includes assignment.errors[:vehicle], "must exist"
  end

  # test "the truth" do
  #   assert true
  # end
end
