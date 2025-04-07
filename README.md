# PostgreSQL Local Development Environment

This project provides a local PostgreSQL development environment with GitOps practices and proper migration management.

## Project Structure

- `0.start_docker/` - Docker configuration files
- `1.init_database/` - Initial database setup scripts
- `2.auth_schema/` - Authentication schema and related migrations
  - `01_create_auth_schema_up.sql` - Creates the authentication schema
  - `02_create_auth_schema_down.sql` - Rollback script for auth schema
  - `seeds/` - Seed data for auth schema
  - `run_migration.sh` - Script to run auth schema migrations
- `connect.sh` - Utility script to connect to the database

## Prerequisites

- Docker and Docker Compose
- PostgreSQL client (psql)

## Setup Instructions

1. Start the PostgreSQL container:

   ```bash
   cd 0.start_docker
   docker-compose up -d
   ```

2. Initialize the database:

   ```bash
   psql -h localhost -U postgres -d psql_local -f ../1.init_database/01_create_migrations_schema.sql
   ```

3. Apply the auth schema migrations:
   ```bash
   cd 2.auth_schema
   ./run_migration.sh up
   ```

## Connection Details

- Host: localhost
- Port: 5432
- Database: psql_local
- Username: postgres
- Password: postgres

You can quickly connect to the database using the provided script:

```bash
./connect.sh
```

## Seed Data

The project includes seed data for testing and development. To run the seed data:

1. Navigate to the auth schema directory:

   ```bash
   cd 2.auth_schema
   ```

2. Run the seed script:
   ```bash
   psql -h localhost -U postgres -d psql_local -f seeds/seed_auth_users.sql
   ```

This will create two test users:

- Admin user (username: `admin`, password: `admin123`)
- Regular user (username: `user`, password: `user123`)

> **Note**: Make sure to run the migrations before running the seed data.

## Migration Management

Migrations are tracked in the `migrations` schema using the `migration_history` table. Each migration:

- Has a unique version
- Includes a checksum for verification
- Tracks execution time and status
- Stores any error messages if the migration fails

## GitOps Practices

All database changes are version controlled and follow a numbered step approach:

1. Each major change is in its own numbered directory
2. Changes are applied in sequence
3. All configuration is stored in Git
4. Migration history is maintained in the database
