BEGIN;  -- Start transaction

-- Check if migration already exists
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '4.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 4.1.0 already exists in migration_history';
    END IF;
END $$;

-- Enable the pg_graphql extension
CREATE EXTENSION IF NOT EXISTS pg_graphql;  -- Ensure the extension is created if it doesn't exist

-- GraphQL anon default role
CREATE ROLE anon;  -- Create a role named 'anon'

-- Grant all permissions on public schema to anon
GRANT ALL ON SCHEMA public TO anon;  -- Grant permissions on the public schema

-- For newly created resources
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON TABLES TO anon;  -- Grant permissions on new tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON FUNCTIONS TO anon;  -- Grant permissions on new functions
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT ALL ON SEQUENCES TO anon;  -- Grant permissions on new sequences

-- For existing resources
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO anon;  -- Grant permissions on existing tables
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO anon;  -- Grant permissions on existing functions
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO anon;  -- Grant permissions on existing sequences

-- Grant all permissions on graphql schema to anon
GRANT ALL ON SCHEMA graphql TO anon;  -- Grant permissions on the graphql schema
GRANT ALL ON FUNCTION graphql.resolve TO anon;  -- Grant permissions on the resolve function

ALTER DEFAULT PRIVILEGES IN SCHEMA graphql 
    GRANT ALL ON TABLES TO anon;  -- Grant permissions on new tables in graphql schema
ALTER DEFAULT PRIVILEGES IN SCHEMA graphql 
    GRANT ALL ON FUNCTIONS TO anon;  -- Grant permissions on new functions in graphql schema
ALTER DEFAULT PRIVILEGES IN SCHEMA graphql 
    GRANT ALL ON SEQUENCES TO anon;  -- Grant permissions on new sequences in graphql schema

-- GraphQL Entrypoint
CREATE FUNCTION graphql(
    "operationName" text DEFAULT NULL,
    query text DEFAULT NULL,
    variables jsonb DEFAULT NULL,
    extensions jsonb DEFAULT NULL
)
    RETURNS jsonb
    LANGUAGE sql
AS $$
    SELECT graphql.resolve(
        query := query,
        variables := COALESCE(variables, '{}'),
        "operationName" := "operationName",
        extensions := extensions
    );
$$;

-- Expose the public schema to GraphQL
COMMENT ON SCHEMA public IS '@graphql({"inflect_names": true})';  -- Add a comment for GraphQL

-- Track this migration
SELECT migrations.track_migration(
    '4.1.0',
    'add_graphql',
    'sha256_hash_of_this_file', -- Placeholder for actual checksum
    0
); 

COMMIT;  -- End transaction