class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.string :contact_email
      t.string :contact_phone
      t.string :subscription_tier
      t.string :status

      t.timestamps
    end
  end
end
