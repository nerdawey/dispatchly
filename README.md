# Dispatchly

A logistics and dispatch management platform built with Ruby on Rails.

## Features
- Organization, user, vehicle, product, location, and order management
- JWT authentication
- RESTful JSON API
- Role-based access control

## Getting Started

### Prerequisites
- Ruby (3.x recommended)
- Rails (7.x or 8.x)
- PostgreSQL

### Setup
```bash
git clone <your-repo-url>
cd dispatchly
bundle install
rails db:setup
```

### Running the Server
```bash
rails server
```

### Running Tests
```bash
rails test
```

## API Endpoints

### Authentication
- `POST /api/v1/authentication/login` — Login and receive JWT token

### Organizations
- `GET /api/v1/organizations` — List organizations
- `GET /api/v1/organizations/:id` — Show organization
- `POST /api/v1/organizations` — Create organization
- `PATCH/PUT /api/v1/organizations/:id` — Update organization
- `DELETE /api/v1/organizations/:id` — Delete organization

### Users
- `GET /api/v1/users` — List users
- `GET /api/v1/users/:id` — Show user
- `POST /api/v1/users` — Create user
- `PATCH/PUT /api/v1/users/:id` — Update user
- `DELETE /api/v1/users/:id` — Delete user

### Vehicles
- `GET /api/v1/vehicles` — List vehicles
- `GET /api/v1/vehicles/:id` — Show vehicle
- `POST /api/v1/vehicles` — Create vehicle
- `PATCH/PUT /api/v1/vehicles/:id` — Update vehicle
- `DELETE /api/v1/vehicles/:id` — Delete vehicle

### Products
- `GET /api/v1/products` — List products
- `GET /api/v1/products/:id` — Show product
- `POST /api/v1/products` — Create product
- `PATCH/PUT /api/v1/products/:id` — Update product
- `DELETE /api/v1/products/:id` — Delete product

### Locations
- `GET /api/v1/locations` — List locations
- `GET /api/v1/locations/:id` — Show location
- `POST /api/v1/locations` — Create location
- `PATCH/PUT /api/v1/locations/:id` — Update location
- `DELETE /api/v1/locations/:id` — Not allowed (405)

### Orders
- `GET /api/v1/orders` — List orders
- `GET /api/v1/orders/:id` — Show order
- `POST /api/v1/orders` — Create order
- `PATCH/PUT /api/v1/orders/:id` — Update order
- `DELETE /api/v1/orders/:id` — Delete order

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
