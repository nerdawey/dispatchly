require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "valid location" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      address: "123 Test St",
      organization: organization
    )
    assert location.valid?
  end

  test "invalid without name" do
    organization = organizations(:one)

    location = Location.new(
      address: "123 Test St",
      organization: organization
    )
    assert_not location.valid?
    assert_includes location.errors[:name], "can't be blank"
  end

  test "invalid without address" do
    organization = organizations(:one)

    location = Location.new(
      name: "Test Location",
      organization: organization
    )
    assert_not location.valid?
    assert_includes location.errors[:address], "can't be blank"
  end

  test "invalid without organization" do
    location = Location.new(
      name: "Test Location",
      address: "123 Test St"
    )
    assert_not location.valid?
    assert_includes location.errors[:organization], "must exist"
  end

  # test "the truth" do
  #   assert true
  # end
end
