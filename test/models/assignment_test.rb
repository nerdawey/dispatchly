require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  test "valid assignment" do
    assignment = Assignment.new(trip_id: 1, order_id: 1)
    assert assignment.valid?
  end

  test "invalid without trip_id" do
    assignment = Assignment.new(order_id: 1)
    refute assignment.valid?
    assert_includes assignment.errors[:trip_id], "can't be blank"
  end

  test "invalid without order_id" do
    assignment = Assignment.new(trip_id: 1)
    refute assignment.valid?
    assert_includes assignment.errors[:order_id], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
