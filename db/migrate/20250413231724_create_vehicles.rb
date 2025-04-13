class CreateVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :plate_number
      t.decimal :capacity_volume
      t.decimal :capacity_weight
      t.integer :min_temp
      t.integer :max_temp
      t.references :organization, null: false, foreign_key: true
      t.references :current_location, null: false, foreign_key: { to_table: :locations }
      t.string :status
      t.decimal :cost_per_km

      t.timestamps
    end
  end
end
