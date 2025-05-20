require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(email_address: "test@example.com", password: "password", role: :super_admin)
    assert user.valid?
  end

  test "invalid without email_address" do
    user = User.new(password: "password", role: :super_admin)
    refute user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "invalid without password" do
    user = User.new(email_address: "test@example.com", role: :super_admin)
    refute user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "invalid without role" do
    user = User.new(email_address: "test@example.com", password: "password")
    refute user.valid?
    assert_includes user.errors[:role], "can't be blank"
  end

  test "super_admin does not require organization" do
    user = User.new(email_address: "test@example.com", password: "password", role: :super_admin)
    assert user.valid?
  end

  test "non-super_admin requires organization" do
    user = User.new(email_address: "test@example.com", password: "password", role: :org_admin)
    refute user.valid?
    assert_includes user.errors[:organization], "must exist unless user is a super admin"
  end

  # test "the truth" do
  #   assert true
  # end
end
