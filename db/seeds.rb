# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(
  email_address: 'admin@example.com',
  password: 'supersecurepassword',
  password_confirmation: 'supersecurepassword',
  role: :super_admin  
)
org = Organization.create!(
  name: "Acme Logistics"
)

User.create!(
  email_address: "admin@acme.com",
  password: "password123",
  password_confirmation: "password123",
  role: :org_admin,
  organization: org
)

# Create a planning user
User.create!(
  email_address: "planner@acme.com",
  password: "password123",
  password_confirmation: "password123",
  role: :planner,
  organization: org
)

# Create a dispatching user
User.create!(
  email_address: "dispatcher@acme.com",
  password: "password123",
  password_confirmation: "password123",
  role: :dispatcher,
  organization: org
)

puts "Seeded: 1 org + 3 users"