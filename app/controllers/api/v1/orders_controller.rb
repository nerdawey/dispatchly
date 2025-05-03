class Api::V1::OrdersController < ApplicationController
    def create
      ActiveRecord::Base.transaction do
        @order = Order.new(order_params)

        if @order.save
          params[:order_items]&.each do |item|
            @order.order_items.create!(
              product_id: item[:product_id],
              quantity: item[:quantity]
            )
          end

          render json: @order.as_json(include: :order_items), status: :created
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def create_bulk_orders_from_excel(file)
      spreadsheet = Roo::Spreadsheet.open(file.path)
      header = spreadsheet.row(1)
      orders = []

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[ header, spreadsheet.row(i) ].transpose]
        orders << Order.new(
          customer_name: row["Customer Name"],
          product_id: Product.find_by(name: row["Product"])&.id,
          quantity: row["Quantity"],
          status: row["Status"],
          order_type: row["Order Type"],
          pickup_location_id: Location.find_by(name: row["Pickup Location"])&.id,
          dropoff_location_id: Location.find_by(name: row["Dropoff Location"])&.id,
          warehouse_id: Warehouse.find_by(name: row["Warehouse"])&.id,
          deadline: row["Deadline"]
        )
      end

      if orders.all?(&:valid?)
        orders.each(&:save!)
        render json: { message: "#{orders.count} orders created" }, status: :created
      else
        render json: orders.map(&:errors), status: :unprocessable_entity
      end
    end

    private

    def order_params
      params.require(:order).permit(
        :customer_name, :product_id, :quantity, :status,
        :pickup_location_id, :dropoff_location_id, :warehouse_id,
        :deadline, :order_type
      )
    end
end
