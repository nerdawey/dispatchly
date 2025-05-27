require "test_helper"

class AbilityTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) # org_admin
    @product = products(:one)
    @other_product = products(:two)
    @product.update!(organization_id: @user.organization_id)
  end

  test "org_admin can manage product in their own organization" do
    ability = Ability.new(@user)
    assert ability.can?(:manage, @product), "org_admin should be able to manage product in their org"
  end

  test "org_admin cannot manage product in another organization" do
    ability = Ability.new(@user)
    assert_not ability.can?(:manage, @other_product), "org_admin should NOT be able to manage product in another org"
  end
end
