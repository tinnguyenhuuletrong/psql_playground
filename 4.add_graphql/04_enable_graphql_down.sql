BEGIN;  -- Start transaction

-- Remove GraphQL comment from public schema
COMMENT ON SCHEMA public IS NULL;  -- Remove the comment for GraphQL

-- Revoke permissions on public schema
REVOKE ALL ON SCHEMA public FROM anon;  -- Revoke all permissions on the public schema
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM anon;  -- Revoke permissions on new tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON FUNCTIONS FROM anon;  -- Revoke permissions on new functions
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM anon;  -- Revoke permissions on new sequences

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM anon;  -- Revoke permissions on existing tables
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM anon;  -- Revoke permissions on existing functions
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM anon;  -- Revoke permissions on existing sequences

REVOKE ALL ON FUNCTION graphql.resolve FROM anon;  -- Revoke permissions on the resolve function

-- Revoke permissions on graphql schema
REVOKE ALL ON SCHEMA graphql FROM anon;  -- Revoke all permissions on the graphql schema
ALTER DEFAULT PRIVILEGES IN SCHEMA graphql REVOKE ALL ON TABLES FROM anon;  -- Revoke permissions on new tables in graphql schema
ALTER DEFAULT PRIVILEGES IN SCHEMA graphql REVOKE ALL ON FUNCTIONS FROM anon;  -- Revoke permissions on new functions in graphql schema
ALTER DEFAULT PRIVILEGES IN SCHEMA graphql REVOKE ALL ON SEQUENCES FROM anon;  -- Revoke permissions on new sequences in graphql schema

-- Drop the anon role if it is no longer needed
DROP ROLE IF EXISTS anon;  -- Drop the anon role

-- Drop the graphql function
DROP FUNCTION IF EXISTS graphql;  -- Drop the graphql function

-- Drop the pg_graphql extension
DROP EXTENSION IF EXISTS pg_graphql;  -- Drop the pg_graphql extension

-- Remove migration record
DELETE FROM migrations.migration_history WHERE version = '4.1.0';  -- Remove the migration record

COMMIT;  -- End transaction