class UpdateOrganizationForeignKeys < ActiveRecord::Migration[8.0]
  def change
    # Remove existing foreign keys
    remove_foreign_key :users, :organizations
    remove_foreign_key :vehicles, :organizations
    remove_foreign_key :locations, :organizations
    remove_foreign_key :products, :organizations
    remove_foreign_key :orders, :organizations
    remove_foreign_key :trips, :organizations

    # Add foreign keys with on_delete: :cascade
    add_foreign_key :users, :organizations, on_delete: :cascade
    add_foreign_key :vehicles, :organizations, on_delete: :cascade
    add_foreign_key :locations, :organizations, on_delete: :cascade
    add_foreign_key :products, :organizations, on_delete: :cascade
    add_foreign_key :orders, :organizations, on_delete: :cascade
    add_foreign_key :trips, :organizations, on_delete: :cascade
  end
end 