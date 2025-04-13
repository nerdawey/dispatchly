class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.decimal :weight
      t.decimal :volume
      t.integer :required_temperature
      t.references :organization, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
