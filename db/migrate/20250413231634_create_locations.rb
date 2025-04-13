class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.references :organization, null: false, foreign_key: true
      t.string :location_type
      t.string :status

      t.timestamps
    end
  end
end
