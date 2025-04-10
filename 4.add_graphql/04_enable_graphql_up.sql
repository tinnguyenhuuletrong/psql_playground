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
CREATE EXTENSION IF NOT EXISTS pg_graphql;

-- GraphQL anon default role
create role anon;

-- all permission on pubic schema
grant all on schema public to anon;

-- for new created resources
alter default privileges in schema public grant all on tables to anon;
alter default privileges in schema public grant all on functions to anon;
alter default privileges in schema public grant all on sequences to anon;

-- for existing resources
grant all privileges on all tables in schema public to anon;
grant all privileges on all functions in schema public to anon;
grant all privileges on all sequences in schema public to anon;


-- all permission on graphql schema
grant all on schema graphql to anon;
grant all on function graphql.resolve to anon;

alter default privileges in schema graphql grant all on tables to anon;
alter default privileges in schema graphql grant all on functions to anon;
alter default privileges in schema graphql grant all on sequences to anon;


-- GraphQL Entrypoint
create function graphql(
    "operationName" text default null,
    query text default null,
    variables jsonb default null,
    extensions jsonb default null
)
    returns jsonb
    language sql
as $$
    select graphql.resolve(
        query := query,
        variables := coalesce(variables, '{}'),
        "operationName" := "operationName",
        extensions := extensions
    );
$$;

-- Expose the public schema to GraphQL
COMMENT ON SCHEMA public IS '@graphql({"inflect_names": true})';

-- Track this migration
SELECT migrations.track_migration(
    '4.1.0',
    'add_graphql',
    'sha256_hash_of_this_file', -- Placeholder It is going to be replaced with actual checksum when sh script run
    0
); 

COMMIT;  -- End transaction