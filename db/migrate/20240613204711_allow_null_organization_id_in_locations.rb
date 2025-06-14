class AllowNullOrganizationIdInLocations < ActiveRecord::Migration[7.0]
  def change
    change_column_null :locations, :organization_id, true
  end
end 