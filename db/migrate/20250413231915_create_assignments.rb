class CreateAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :assignments do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.string :status
      t.datetime :estimated_start_time
      t.datetime :estimated_completion_time
      t.decimal :total_distance

      t.timestamps
    end
  end
end
