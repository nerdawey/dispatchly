class MakeRequiredTemperatureNonNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :required_temperature, false
  end
end 