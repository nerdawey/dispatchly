class AddVehicleIdToTrips < ActiveRecord::Migration[8.0]
  def change
    add_reference :trips, :vehicle, null: false, foreign_key: true
  end
end
