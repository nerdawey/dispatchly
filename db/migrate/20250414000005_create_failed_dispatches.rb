class CreateFailedDispatches < ActiveRecord::Migration[8.0]
  def change
    create_table :failed_dispatches do |t|
      t.text :reason
      t.datetime :attempted_at
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end 