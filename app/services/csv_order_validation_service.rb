require 'csv'

class CsvOrderValidationService
  REQUIRED_HEADERS = %w[order_number pickup_location delivery_location product_sku quantity status order_type delivery_deadline pickup_time_window_start pickup_time_window_end]

  attr_reader :errors, :valid_orders

  def initialize(file)
    @file = file
    @errors = []
    @valid_orders = []
  end

  def validate_and_parse
    csv = CSV.parse(@file.read, headers: true)
    missing_headers = REQUIRED_HEADERS - csv.headers.map(&:strip)
    unless missing_headers.empty?
      @errors << "Missing required columns: #{missing_headers.join(', ')}"
      return false
    end

    csv.each_with_index do |row, idx|
      row_errors = []
      order_data = {}
      REQUIRED_HEADERS.each do |header|
        value = row[header]
        if value.nil? || value.strip.empty?
          row_errors << "Row #{idx+2}: Missing value for '#{header}'"
        else
          order_data[header] = value.strip
        end
      end

      # Additional validations (example: quantity must be integer)
      if order_data['quantity'] && order_data['quantity'].to_i.to_s != order_data['quantity']
        row_errors << "Row #{idx+2}: Quantity must be an integer"
      end

      if row_errors.any?
        @errors.concat(row_errors)
      else
        @valid_orders << order_data
      end
    end

    @errors.empty?
  end
end 