class Api::V1::OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: [ :show, :update, :destroy ]
  require 'csv'

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

  # POST /api/v1/orders/import_csv
  def import_csv
    file = params[:file]
    unless file && file.respond_to?(:read)
      return render json: { error: 'No CSV file uploaded' }, status: :bad_request
    end

    file.rewind

    validator = CsvOrderValidationService.new(file)
    if !validator.validate_and_parse
      return render json: { errors: validator.errors }, status: :unprocessable_entity
    end

    created_orders = []
    ActiveRecord::Base.transaction do
      validator.valid_orders.each do |order_data|
        # Map CSV fields to model fields
        pickup_location = Location.find_by(name: order_data['pickup_location'])
        delivery_location = Location.find_by(name: order_data['delivery_location'])
        product = Product.find_by(sku: order_data['product_sku'])
        if pickup_location.nil? || delivery_location.nil? || product.nil?
          raise ActiveRecord::Rollback, "Invalid location or product for order #{order_data['order_number']}"
        end
        Rails.logger.info "DEBUG: order_data = \\#{order_data.inspect}"
        order = Order.create!(
          order_number: order_data['order_number'],
          organization: current_user.organization,
          pickup_location: pickup_location,
          delivery_location: delivery_location,
          status: order_data['status'],
          order_type: order_data['order_type'],
          delivery_deadline: (order_data['delivery_deadline'].present? ? Date.parse(order_data['delivery_deadline']) : nil),
          pickup_time_window_start: (order_data['pickup_time_window_start'].present? ? Time.parse(order_data['pickup_time_window_start']) : nil),
          pickup_time_window_end: (order_data['pickup_time_window_end'].present? ? Time.parse(order_data['pickup_time_window_end']) : nil)
        )
        order_item = order.order_items.create!(product: product, quantity: order_data['quantity'].to_i)

        # Update product quantity
        new_quantity = product.number_of_boxes - order_data['quantity'].to_i
        if new_quantity < 0
          raise "Not enough boxes available for product #{product.sku}"
        end
        product.update!(number_of_boxes: new_quantity)

        # Calculate and update total weight
        total_weight = product.weight * order_data['quantity'].to_i
        order.update!(total_weight: total_weight)

        created_orders << order
      end
    end
    render json: { message: "#{created_orders.size} orders created", orders: created_orders.as_json(include: :order_items) }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
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
