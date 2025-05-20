# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_20_052017) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "vehicle_id", null: false
    t.string "status"
    t.datetime "estimated_start_time"
    t.datetime "estimated_completion_time"
    t.decimal "total_distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_assignments_on_trip_id"
    t.index ["vehicle_id"], name: "index_assignments_on_vehicle_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.bigint "organization_id", null: false
    t.string "location_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_locations_on_organization_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number"
    t.bigint "organization_id", null: false
    t.bigint "pickup_location_id", null: false
    t.bigint "delivery_location_id", null: false
    t.datetime "pickup_time_window_start"
    t.datetime "pickup_time_window_end"
    t.datetime "delivery_deadline"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_type"
    t.index ["delivery_location_id"], name: "index_orders_on_delivery_location_id"
    t.index ["organization_id"], name: "index_orders_on_organization_id"
    t.index ["pickup_location_id"], name: "index_orders_on_pickup_location_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "subscription_tier"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.decimal "weight"
    t.decimal "volume"
    t.integer "required_temperature"
    t.bigint "organization_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "storage_temperature", default: 0, null: false
    t.index ["organization_id"], name: "index_products_on_organization_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.string "status"
    t.date "scheduled_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "vehicle_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["organization_id"], name: "index_trips_on_organization_id"
    t.index ["vehicle_id"], name: "index_trips_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.bigint "organization_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "plate_number"
    t.decimal "capacity_volume"
    t.decimal "capacity_weight"
    t.integer "min_temp"
    t.integer "max_temp"
    t.bigint "organization_id", null: false
    t.bigint "current_location_id", null: false
    t.string "status"
    t.decimal "cost_per_km"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_location_id"], name: "index_vehicles_on_current_location_id"
    t.index ["organization_id"], name: "index_vehicles_on_organization_id"
  end

  add_foreign_key "assignments", "trips"
  add_foreign_key "assignments", "vehicles"
  add_foreign_key "locations", "organizations"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "locations", column: "delivery_location_id"
  add_foreign_key "orders", "locations", column: "pickup_location_id"
  add_foreign_key "orders", "organizations"
  add_foreign_key "products", "organizations"
  add_foreign_key "sessions", "users"
  add_foreign_key "trips", "organizations"
  add_foreign_key "trips", "vehicles"
  add_foreign_key "users", "organizations"
  add_foreign_key "vehicles", "locations", column: "current_location_id"
  add_foreign_key "vehicles", "organizations"
end
