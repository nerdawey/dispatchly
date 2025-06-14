class Api::V1::OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: [ :show, :update, :destroy ]

  def index
    if params[:trip_id]
      @orders = current_user.organization.orders
        .where(trip_id: params[:trip_id])
        .includes(order_items: :product, pickup_location: {}, delivery_location: {})
        .order(created_at: :desc)
    elsif current_user.super_admin?
      @orders = Order.all.includes(order_items: :product, pickup_location: {}, delivery_location: {}).order(created_at: :desc)
    else
      @orders = current_user.organization.orders
        .includes(order_items: :product, pickup_location: {}, delivery_location: {})
        .order(created_at: :desc)
    end

    render json: {
      orders: @orders.as_json(
        include: [
          { order_items: { include: :product } },
          :pickup_location,
          :delivery_location
        ]
      )
    }
  end

  def show
    render json: @order.as_json(include: [ :order_items, :pickup_location, :delivery_location ])
  end

  def create
    ActiveRecord::Base.transaction do
      @order = Order.new(order_params)
      @order.order_number = params[:order][:order_number]

      if @order.save
        total_weight = 0
        params[:order_items]&.each do |item|
          @order.order_items.create!(
            product_id: item[:product_id],
            quantity: item[:quantity]
          )

          product = Product.find(item[:product_id])
          item_weight = product.weight * item[:quantity]
          total_weight += item_weight

          new_quantity = product.number_of_boxes - item[:quantity]
          if new_quantity < 0
            raise "Not enough boxes available for product #{product.sku}"
          end
          product.update!(number_of_boxes: new_quantity)
        end

        @order.update!(total_weight: total_weight)

        render json: @order.as_json(include: :order_items), status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    if @order.update(order_params)
      render json: @order.as_json(include: [ :order_items, :pickup_location, :delivery_location ])
    else
      render json: { errors: @order.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @order.order_items.destroy_all
      @order.destroy
      head :no_content
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

  def set_order
    @order = current_user.organization.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Order not found" }, status: :not_found
  end

  def order_params
    params.expect(
      order: [ :order_number,
      :organization_id,
      :pickup_location_id,
      :delivery_location_id,
      :pickup_time_window_start,
      :pickup_time_window_end,
      :delivery_deadline,
      :status,
      :order_type ]
    )
  end
end
