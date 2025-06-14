class AddTripIdToOrders < ActiveRecord::Migration[8.0]
    def change
      add_reference :orders, :trip, foreign_key: true
    end
  end