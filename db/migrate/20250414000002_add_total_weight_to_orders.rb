class AddTotalWeightToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :total_weight, :decimal, precision: 10, scale: 2
  end
end 