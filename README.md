# PostgreSQL Local Development Environment

This project provides a local PostgreSQL development environment with GitOps practices and proper migration management.

## Project Structure

- `0.start_docker/` - Docker configuration files
- `1.init_database/` - Initial database setup scripts
- `migrations/` - Database migration files (to be added)

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

## Connection Details

- Host: localhost
- Port: 5432
- Database: psql_local
- Username: postgres
- Password: postgres

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
