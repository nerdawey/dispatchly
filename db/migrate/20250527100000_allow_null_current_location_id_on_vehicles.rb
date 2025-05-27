class AllowNullCurrentLocationIdOnVehicles < ActiveRecord::Migration[8.0]
  def change
    change_column_null :vehicles, :current_location_id, true
  end
end 