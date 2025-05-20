require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  test 'valid vehicle' do
    vehicle = Vehicle.new(capacity: 100, organization_id: 1)
    assert vehicle.valid?
  end

  test 'invalid without capacity' do
    vehicle = Vehicle.new(organization_id: 1)
    refute vehicle.valid?
    assert_includes vehicle.errors[:capacity], "can't be blank"
  end

  test 'invalid without organization_id' do
    vehicle = Vehicle.new(capacity: 100)
    refute vehicle.valid?
    assert_includes vehicle.errors[:organization_id], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
