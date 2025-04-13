class CreateTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :trips do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true
      t.string :status
      t.date :scheduled_date

      t.timestamps
    end
  end
end
