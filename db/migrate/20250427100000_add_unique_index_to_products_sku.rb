class AddUniqueIndexToProductsSku < ActiveRecord::Migration[8.0]
  def change
    add_index :products, [:sku, :organization_id], unique: true
  end
end 