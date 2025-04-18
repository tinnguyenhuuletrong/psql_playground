# PostgreSQL Local Development Environment

This project provides a local PostgreSQL development environment with GitOps practices and proper migration management.

## Project Structure

- `0.start_docker/` - Docker configuration files
- `1.init_database/` - Initial database setup scripts
- `2.auth_schema/` - Authentication schema and related migrations
- `3.user_todos/` - User todos schema and related migrations
- `4.add_graphql/` - GraphQL extension and related migrations
- `5.add_graphql_elements/` - Additional GraphQL elements and related migrations
- `6.row_level_security/` - Additional PSQL Row Security Policies
- `scripts` - Utility script to connect to the database
- `.gitignore` - Specifies which files Git should ignore

## Prerequisites

- Docker and Docker Compose
- PostgreSQL client (psql)

## Connection Details

- Host: localhost
- Port: 5432
- Database: psql_local
- Username: postgres
- Password: postgres

You can quickly connect to the database using the provided script:

```bash
./scripts/connect.sh
```

## Development

### Reset and Run Docker

To reset the Docker environment and start fresh, use the following script:

```bash
cd scripts
./0.reset_and_run_docker.sh
```

### Migrate Up All

To run all migrations and seed the database, execute:

```bash
cd scripts
./1.migrate_up_all.sh
```

### Connecting and Testing Row-Level Security (RLS)

To test Row-Level Security (RLS), follow these steps:

**Using psql CLI**

First, connect to the database using the provided script:

```bash
./scripts/connect.sh
```

Once connected, execute the following SQL commands to simulate an anonymous user session:

```sql
-- Set the JWT claims for user_id and switch to the anon role
SET request.jwt.claims TO '{ "user_id": "<UUID>" }'; SET ROLE anon;
```

After setting the role, you should only see user_todos records owned by the user with the specified UUID.

**Using graphiql.index.html**

To test RLS using the GraphiQL interface, you need to set a request header with a valid JWT token. The JWT token should contain the user_id as its payload.

Here's an example of how the JWT payload should look:

```json
{
  "user_id": "<UUID>"
}
```

You can generate a JWT token using tools like [jwt.io](https://jwt.io/). The JWT secret key can be found in the `PGRST_JWT_SECRET` environment variable in the `docker_compose.yml` file.

Once you have the JWT token, set it in the request header as follows:

```json
{
  "Authorization": "Bearer <JWT token>"
}
```

This will allow you to test RLS using the GraphiQL interface with the specified user_id.

## Migration Management

Migrations are tracked in the `migrations` schema using the `migration_history` table. Each migration:

- Has a unique version
- Includes a checksum for verification
- Tracks execution time and status
- Stores any error messages if the migration fails

The project now includes GraphQL functionality, allowing for flexible data querying and manipulation through the `pg_graphql` extension.

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

The project uses Git for version control with the following practices:

1. **Database Changes**: All database changes (schemas, migrations, seeds) are version controlled
2. **Sequential Changes**: Changes are applied in numbered sequence (e.g., `01_`, `02_`)
3. **Migration Tracking**: Each migration is tracked both in Git and the database
4. **Configuration as Code**: All configuration files are stored in Git

### Recommended .gitignore Rules

Add the following rules to your `.gitignore` file:
