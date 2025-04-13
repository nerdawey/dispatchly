class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.references :organization, null: false, foreign_key: true
      t.references :pickup_location, null: false, foreign_key: { to_table: :locations }
      t.references :delivery_location, null: false, foreign_key: { to_table: :locations }
      t.datetime :pickup_time_window_start
      t.datetime :pickup_time_window_end
      t.datetime :delivery_deadline
      t.string :status
      t.string :order_type

      t.timestamps
    end
  end
end
