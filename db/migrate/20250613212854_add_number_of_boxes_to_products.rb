class AddNumberOfBoxesToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :number_of_boxes, :integer
  end
end
