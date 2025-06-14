class UpdateVehiclesForFrontendAlignment < ActiveRecord::Migration[8.0]
  def change
    add_column :vehicles, :model, :string
    add_column :vehicles, :year, :integer
    add_column :vehicles, :box_type, :string
    add_column :vehicles, :last_maintenance_date, :date
    add_column :vehicles, :freezing_available, :boolean, default: false
    add_column :vehicles, :box_volume, :decimal

    remove_column :vehicles, :min_temp, :integer
    remove_column :vehicles, :max_temp, :integer
    remove_column :vehicles, :name, :string
  end
end
