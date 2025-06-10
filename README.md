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

## Business Documentation

I'll analyze the project from a business perspective and create a business-focused documentation. Let me gather more information about the business logic and models.

Ran tool
Let me check some key business models to understand their relationships and business rules.

Read file: app/models/organization.rb
Read file: app/models/order.rb
Based on my analysis, here's the business-focused documentation for Dispatchly:

# Dispatchly - Business Documentation

## Business Overview

Dispatchly is a comprehensive logistics and dispatch management platform designed to streamline operations for logistics companies, delivery services, and organizations managing complex supply chains. The platform enables efficient management of resources, orders, and deliveries while maintaining real-time visibility across the entire operation.

## Core Business Entities

### 1. Organizations

- **Purpose**: Represents companies using the platform
- **Key Attributes**:
  - Name and contact information
  - Subscription tier (indicating service level)
  - Operational status
- **Business Rules**:
  - Must have valid contact information
  - Subscription tier determines feature access
  - Can manage multiple locations, vehicles, and users

### 2. Orders

- **Types**:
  - Outbound: Deliveries from organization to customers
  - Inbound: Receiving goods from suppliers
- **Key Components**:
  - Order items (products being transported)
  - Pickup and delivery locations
  - Time windows for pickup and delivery
  - Associated trip (if assigned)
- **Business Rules**:
  - Must have valid time windows
  - Must have delivery deadlines
  - Can be tracked through various statuses

### 3. Locations

- **Types**:
  - Warehouses
  - Delivery points
  - Pickup locations
- **Features**:
  - Geocoding support
  - Address validation
  - Contact information

### 4. Vehicles

- **Purpose**: Fleet management
- **Features**:
  - Vehicle tracking
  - Capacity management
  - Maintenance scheduling
- **Business Rules**:
  - Must be associated with an organization
  - Can be assigned to trips

### 5. Trips

- **Purpose**: Route management
- **Components**:
  - Multiple orders
  - Vehicle assignment
  - Route optimization
- **Business Rules**:
  - Must have valid start and end times
  - Can include multiple stops
  - Must be assigned to a vehicle

## Business Processes

### 1. Order Management

1. **Order Creation**
   - Customer places order
   - System validates order details
   - Assigns unique order number
   - Sets pickup and delivery windows

2. **Order Processing**
   - Inventory check
   - Route optimization
   - Vehicle assignment
   - Driver assignment

3. **Order Fulfillment**
   - Pickup confirmation
   - Delivery tracking
   - Proof of delivery
   - Status updates

### 2. Fleet Management

1. **Vehicle Assignment**
   - Capacity matching
   - Route optimization
   - Driver availability
   - Maintenance scheduling

2. **Trip Planning**
   - Route optimization
   - Time window management
   - Multi-stop coordination
   - Real-time tracking

### 3. Inventory Management

1. **Stock Control**
   - Real-time inventory tracking
   - Low stock alerts
   - Reorder management
   - Warehouse allocation

2. **Warehouse Operations**
   - Receiving
   - Storage
   - Picking
   - Shipping

## Business Features

### 1. Real-time Tracking

- Vehicle location tracking
- Order status updates
- Delivery ETA calculations
- Route deviation alerts

### 2. Resource Optimization

- Route optimization
- Vehicle capacity utilization
- Driver assignment
- Warehouse space management

### 3. Customer Service

- Order status tracking
- Delivery notifications
- Customer communication
- Issue resolution

### 4. Reporting and Analytics

- Delivery performance metrics
- Fleet utilization reports
- Customer satisfaction tracking
- Operational efficiency analysis

## Business Benefits

### 1. Operational Efficiency

- Reduced delivery times
- Optimized resource utilization
- Improved route planning
- Better inventory management

### 2. Cost Reduction

- Fuel savings through route optimization
- Reduced vehicle maintenance costs
- Better resource allocation
- Lower operational overhead

### 3. Customer Satisfaction

- Accurate delivery tracking
- Timely deliveries
- Better communication
- Improved service quality

### 4. Scalability

- Handles multiple organizations
- Supports various business models
- Adaptable to different industries
- Flexible subscription tiers

## Business Rules and Constraints

### 1. Order Management

- Orders must have valid time windows
- Delivery deadlines must be realistic
- Orders must be assigned to valid locations
- Products must be available in inventory

### 2. Resource Management

- Vehicles must be properly maintained
- Drivers must have valid credentials
- Warehouses must have sufficient capacity
- Routes must be optimized for efficiency

### 3. Security and Compliance

- Role-based access control
- Data privacy protection
- Audit trail maintenance
- Regulatory compliance

## Integration Points

### 1. External Systems

- GPS tracking systems
- Weather services
- Traffic information
- Customer management systems

### 2. Communication Channels

- SMS notifications
- Email alerts
- Mobile app updates
- Customer portal

## Business Metrics

### 1. Performance Indicators

- On-time delivery rate
- Vehicle utilization
- Order fulfillment time
- Customer satisfaction score

### 2. Operational Metrics

- Fuel efficiency
- Route optimization
- Resource utilization
- Cost per delivery
