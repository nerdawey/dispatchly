require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "valid location" do
    location = Location.new(address: "123 Test St", latitude: 40.7128, longitude: -74.0060)
    assert location.valid?
  end

  test "invalid without address" do
    location = Location.new(latitude: 40.7128, longitude: -74.0060)
    refute location.valid?
    assert_includes location.errors[:address], "can't be blank"
  end

  test "invalid without latitude" do
    location = Location.new(address: "123 Test St", longitude: -74.0060)
    refute location.valid?
    assert_includes location.errors[:latitude], "can't be blank"
  end

  test "invalid without longitude" do
    location = Location.new(address: "123 Test St", latitude: 40.7128)
    refute location.valid?
    assert_includes location.errors[:longitude], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
