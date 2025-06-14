class RemoveAddressAndSubscriptionTierFromOrganizations < ActiveRecord::Migration[8.0]
  def change
    remove_column :organizations, :address, :string
    remove_column :organizations, :subscription_tier, :string
  end
end
