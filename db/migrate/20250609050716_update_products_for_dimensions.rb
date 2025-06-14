class UpdateProductsForDimensions < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :name, :string
    remove_column :products, :volume, :decimal
    add_column :products, :length, :decimal
    add_column :products, :width, :decimal
    add_column :products, :height, :decimal
  end
end
