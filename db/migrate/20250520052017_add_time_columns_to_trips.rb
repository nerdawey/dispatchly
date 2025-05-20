class AddTimeColumnsToTrips < ActiveRecord::Migration[8.0]
  def change
    add_column :trips, :start_time, :datetime
    add_column :trips, :end_time, :datetime
  end
end
