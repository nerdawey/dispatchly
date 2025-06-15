require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "valid organization" do
    organization = Organization.new(
      name: "Test Organization",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      status: "active"
    )
    assert organization.valid?
  end

  test "invalid without name" do
    organization = Organization.new(
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      status: "active"
    )
    assert_not organization.valid?
    assert_includes organization.errors[:name], "can't be blank"
  end

  test "invalid without contact_email" do
    organization = Organization.new(
      name: "Test Organization",
      contact_phone: "123-456-7890",
      status: "active"
    )
    assert_not organization.valid?
    assert_includes organization.errors[:contact_email], "can't be blank"
  end

  test "invalid without contact_phone" do
    organization = Organization.new(
      name: "Test Organization",
      contact_email: "test@example.com",
      status: "active"
    )
    assert_not organization.valid?
    assert_includes organization.errors[:contact_phone], "can't be blank"
  end

  test "invalid without status" do
    organization = Organization.new(
      name: "Test Organization",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890"
    )
    assert_not organization.valid?
    assert_includes organization.errors[:status], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
