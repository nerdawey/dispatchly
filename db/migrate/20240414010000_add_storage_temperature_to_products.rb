class AddStorageTemperatureToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :storage_temperature, :integer, default: 0, null: false
  end
end 