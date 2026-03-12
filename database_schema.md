# OtoLog - Online SQL Database Schema

This document contains the SQL schema for migrating the OtoLog app from Isar (local database) to an online SQL database.

## Database: otolog_db

### Tables

#### 1. vehicles

Stores vehicle information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique vehicle identifier |
| name | VARCHAR(255) | NOT NULL | Vehicle name/nickname |
| plate_number | VARCHAR(50) | NOT NULL, UNIQUE | License plate number |
| brand | VARCHAR(100) | NULL | Vehicle brand/manufacturer |
| model | VARCHAR(100) | NULL | Vehicle model |
| year | VARCHAR(10) | NULL | Manufacturing year |
| color | VARCHAR(50) | NULL | Vehicle color |
| type | VARCHAR(50) | NULL | Vehicle type (e.g., sedan, SUV, motorcycle) |
| created_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Last update timestamp |

```sql
CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    plate_number VARCHAR(50) NOT NULL UNIQUE,
    brand VARCHAR(100),
    model VARCHAR(100),
    year VARCHAR(10),
    color VARCHAR(50),
    type VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### 2. service_records

Stores service/maintenance records for vehicles.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Unique service record identifier |
| vehicle_id | INT | NOT NULL, FOREIGN KEY → vehicles(id) | Reference to vehicle |
| service_type | VARCHAR(100) | NOT NULL | Type of service (e.g., oil change, tire rotation) |
| service_date | DATE | NOT NULL | Date when service was performed |
| description | TEXT | NULL | Detailed description of service |
| cost | DECIMAL(10, 2) | NULL | Cost of the service |
| mechanic | VARCHAR(255) | NULL | Name of the mechanic/shop |
| notes | TEXT | NULL | Additional notes |
| created_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |
| updated_at | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP | Last update timestamp |

```sql
CREATE TABLE service_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    service_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2),
    mechanic VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);
```

## Indexes

Create indexes for better query performance:

```sql
-- Index on vehicles table
CREATE INDEX idx_vehicles_plate_number ON vehicles(plate_number);
CREATE INDEX idx_vehicles_brand ON vehicles(brand);
CREATE INDEX idx_vehicles_type ON vehicles(type);
CREATE INDEX idx_vehicles_created_at ON vehicles(created_at);

-- Index on service_records table
CREATE INDEX idx_service_records_vehicle_id ON service_records(vehicle_id);
CREATE INDEX idx_service_records_service_date ON service_records(service_date);
CREATE INDEX idx_service_records_service_type ON service_records(service_type);
CREATE INDEX idx_service_records_created_at ON service_records(created_at);

-- Composite index for common queries
CREATE INDEX idx_service_records_vehicle_date ON service_records(vehicle_id, service_date DESC);
```

## Complete Schema Creation Script

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS otolog_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE otolog_db;

-- Create vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    plate_number VARCHAR(50) NOT NULL UNIQUE,
    brand VARCHAR(100),
    model VARCHAR(100),
    year VARCHAR(10),
    color VARCHAR(50),
    type VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create service_records table
CREATE TABLE IF NOT EXISTS service_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    service_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(10, 2),
    mechanic VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes
CREATE INDEX idx_vehicles_plate_number ON vehicles(plate_number);
CREATE INDEX idx_vehicles_brand ON vehicles(brand);
CREATE INDEX idx_vehicles_type ON vehicles(type);
CREATE INDEX idx_vehicles_created_at ON vehicles(created_at);

CREATE INDEX idx_service_records_vehicle_id ON service_records(vehicle_id);
CREATE INDEX idx_service_records_service_date ON service_records(service_date);
CREATE INDEX idx_service_records_service_type ON service_records(service_type);
CREATE INDEX idx_service_records_created_at ON service_records(created_at);
CREATE INDEX idx_service_records_vehicle_date ON service_records(vehicle_id, service_date DESC);
```

## Sample Queries

### Insert a new vehicle

```sql
INSERT INTO vehicles (name, plate_number, brand, model, year, color, type)
VALUES ('My Car', 'B 1234 ABC', 'Toyota', 'Avanza', '2020', 'Silver', 'MPV');
```

### Insert a service record

```sql
INSERT INTO service_records (vehicle_id, service_type, service_date, description, cost, mechanic, notes)
VALUES (1, 'Oil Change', '2024-03-10', 'Regular oil change with filter replacement', 500000.00, 'Bengkel Jaya', 'Used synthetic oil');
```

### Get all vehicles with their service count

```sql
SELECT 
    v.*,
    COUNT(sr.id) as total_services,
    SUM(sr.cost) as total_cost
FROM vehicles v
LEFT JOIN service_records sr ON v.id = sr.vehicle_id
GROUP BY v.id;
```

### Get service records for a specific vehicle

```sql
SELECT * FROM service_records 
WHERE vehicle_id = 1 
ORDER BY service_date DESC;
```

### Get recent services across all vehicles

```sql
SELECT 
    sr.*,
    v.name as vehicle_name,
    v.plate_number
FROM service_records sr
JOIN vehicles v ON sr.vehicle_id = v.id
ORDER BY sr.service_date DESC
LIMIT 10;
```

### Get monthly service cost summary

```sql
SELECT 
    DATE_FORMAT(service_date, '%Y-%m') as month,
    COUNT(*) as service_count,
    SUM(cost) as total_cost
FROM service_records
WHERE cost IS NOT NULL
GROUP BY DATE_FORMAT(service_date, '%Y-%m')
ORDER BY month DESC;
```

## Migration Notes

### From Isar to SQL

1. **Data Types Mapping**:
   - `int` → `INT` (with AUTO_INCREMENT for primary keys)
   - `String` → `VARCHAR` or `TEXT` depending on expected length
   - `double` → `DECIMAL(10, 2)` for monetary values
   - `DateTime` → `TIMESTAMP` for timestamps, `DATE` for dates

2. **Relationships**:
   - Isar uses embedded relationships
   - SQL uses explicit FOREIGN KEY constraints
   - Added `ON DELETE CASCADE` to automatically delete service records when a vehicle is deleted

3. **Indexes**:
   - Isar automatically indexes certain fields
   - SQL requires explicit index creation for performance
   - Added indexes on commonly queried fields

4. **Timestamps**:
   - Isar sets timestamps in Dart code
   - SQL can handle timestamps automatically with DEFAULT and ON UPDATE clauses

### Recommended Online SQL Database Options

1. **PostgreSQL** (Recommended for production)
   - More features and better data integrity
   - Excellent JSON support
   - Stronger type system

2. **MySQL / MariaDB**
   - Widely used and well-documented
   - Good performance for read-heavy workloads
   - Easier to find hosting options

3. **SQLite** (For simple deployments)
   - Single file database
   - No server required
   - Good for small to medium applications

### Security Considerations

1. Always use parameterized queries to prevent SQL injection
2. Implement proper authentication and authorization
3. Use SSL/TLS for database connections
4. Regular database backups
5. Consider implementing row-level security for multi-user scenarios

### Future Enhancements

Consider adding these tables for future features:

```sql
-- Users table (for multi-user support)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Add user_id to vehicles table
ALTER TABLE vehicles ADD COLUMN user_id INT;
ALTER TABLE vehicles ADD CONSTRAINT fk_vehicles_user 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Reminders table (for service reminders)
CREATE TABLE reminders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    reminder_type VARCHAR(100) NOT NULL,
    reminder_date DATE NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
);
```
