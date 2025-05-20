class UpdateFrozenStorageTemperature < ActiveRecord::Migration[8.0]
  def up
    # Update any existing records that have 'frozen' as their storage_temperature
    execute <<-SQL
      UPDATE products 
      SET storage_temperature = 2 
      WHERE storage_temperature = 2;
    SQL
  end

  def down
    # No need for down migration as the enum values are the same
  end
end 