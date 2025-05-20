class ChangeOrderTypeToInteger < ActiveRecord::Migration[8.0]
    def up
      # First, create a temporary column
      add_column :orders, :order_type_int, :integer
  
      # Update the temporary column based on existing string values
      execute <<-SQL
        UPDATE orders 
        SET order_type_int = CASE 
          WHEN order_type = 'outbound' THEN 0
          WHEN order_type = 'inbound' THEN 1
          ELSE 0
        END
      SQL
  
      # Remove the old column and rename the new one
      remove_column :orders, :order_type
      rename_column :orders, :order_type_int, :order_type
    end
  
    def down
      # First, create a temporary column
      add_column :orders, :order_type_str, :string
  
      # Update the temporary column based on integer values
      execute <<-SQL
        UPDATE orders 
        SET order_type_str = CASE 
          WHEN order_type = 0 THEN 'outbound'
          WHEN order_type = 1 THEN 'inbound'
          ELSE 'outbound'
        END
      SQL
  
      # Remove the old column and rename the new one
      remove_column :orders, :order_type
      rename_column :orders, :order_type_str, :order_type
    end
  end