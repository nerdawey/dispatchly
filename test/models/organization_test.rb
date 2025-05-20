require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "valid organization" do
    organization = Organization.new(
      name: "Test Organization",
      address: "123 Test St",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      subscription_tier: "basic",
      status: "active"
    )
    assert organization.valid?
  end

  test "invalid without name" do
    organization = Organization.new(
      address: "123 Test St",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      subscription_tier: "basic",
      status: "active"
    )
    refute organization.valid?
    assert_includes organization.errors[:name], "can't be blank"
  end

  test "invalid without address" do
    organization = Organization.new(
      name: "Test Organization",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      subscription_tier: "basic",
      status: "active"
    )
    refute organization.valid?
    assert_includes organization.errors[:address], "can't be blank"
  end

  test "invalid without contact_email" do
    organization = Organization.new(
      name: "Test Organization",
      address: "123 Test St",
      contact_phone: "123-456-7890",
      subscription_tier: "basic",
      status: "active"
    )
    refute organization.valid?
    assert_includes organization.errors[:contact_email], "can't be blank"
  end

  test "invalid without contact_phone" do
    organization = Organization.new(
      name: "Test Organization",
      address: "123 Test St",
      contact_email: "test@example.com",
      subscription_tier: "basic",
      status: "active"
    )
    refute organization.valid?
    assert_includes organization.errors[:contact_phone], "can't be blank"
  end

  test "invalid without subscription_tier" do
    organization = Organization.new(
      name: "Test Organization",
      address: "123 Test St",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      status: "active"
    )
    refute organization.valid?
    assert_includes organization.errors[:subscription_tier], "can't be blank"
  end

  test "invalid without status" do
    organization = Organization.new(
      name: "Test Organization",
      address: "123 Test St",
      contact_email: "test@example.com",
      contact_phone: "123-456-7890",
      subscription_tier: "basic"
    )
    refute organization.valid?
    assert_includes organization.errors[:status], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
