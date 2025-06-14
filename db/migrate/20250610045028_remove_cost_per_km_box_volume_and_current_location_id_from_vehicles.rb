class RemoveCostPerKmBoxVolumeAndCurrentLocationIdFromVehicles < ActiveRecord::Migration[8.0]
  def change
    remove_column :vehicles, :cost_per_km, :float
    remove_column :vehicles, :box_volume, :float
    remove_column :vehicles, :current_location_id, :integer
  end
end
