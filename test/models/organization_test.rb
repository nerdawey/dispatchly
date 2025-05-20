require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test 'valid organization' do
    organization = Organization.new(name: 'Test Organization')
    assert organization.valid?
  end

  test 'invalid without name' do
    organization = Organization.new
    refute organization.valid?
    assert_includes organization.errors[:name], "can't be blank"
  end

  # test "the truth" do
  #   assert true
  # end
end
