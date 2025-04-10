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
- `3.user_todos/` - User todos schema and related migrations
  - `03_create_user_todos_up.sql` - Creates the user_todos table in the public schema with appropriate columns and constraints
  - `03_create_user_todos_down.sql` - Drops the table and its index for rollback
  - `seeds/` - Seed data for user todos schema
  - `run_migration.sh` - Script to run user todos schema migrations
- `connect.sh` - Utility script to connect to the database
- `.gitignore` - Specifies which files Git should ignore

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
   ./run_migration.sh up|down|seed
   ```

4. Apply the user todos schema migrations:
   ```bash
   cd 3.user_todos
   chmod +x run_migration.sh
   ./run_migration.sh up|down|seed
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

### Git Workflow

1. Create feature branches for new database changes
2. Include both up and down migration scripts
3. Test migrations locally before committing
4. Use meaningful commit messages describing database changes
5. Review migration checksums before merging

## Version Control and Git Practices

### Git Configuration

The project uses Git for version control with the following practices:

1. **Database Changes**: All database changes (schemas, migrations, seeds) are version controlled
2. **Sequential Changes**: Changes are applied in numbered sequence (e.g., `01_`, `02_`)
3. **Migration Tracking**: Each migration is tracked both in Git and the database
4. **Configuration as Code**: All configuration files are stored in Git

### Recommended .gitignore Rules

Add the following rules to your `.gitignore` file:
