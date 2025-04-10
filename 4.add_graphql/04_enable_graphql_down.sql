BEGIN;  -- Start transaction


-- Remove GraphQL comment from public schema
COMMENT ON SCHEMA public IS NULL;

-- Revoke public schema
revoke all on schema public from anon;
alter default privileges in schema public revoke all on tables from anon;
alter default privileges in schema public revoke all on functions from anon;
alter default privileges in schema public revoke all on sequences from anon;

revoke all privileges on all tables in schema public from anon;
revoke all privileges on all functions in schema public from anon;
revoke all privileges on all sequences in schema public from anon;


revoke all on function graphql.resolve from anon;

-- Revoke graphql schema
revoke all on schema graphql from anon;
alter default privileges in schema graphql revoke all on tables from anon;
alter default privileges in schema graphql revoke all on functions from anon;
alter default privileges in schema graphql revoke all on sequences from anon;


-- Drop the anon role if it is no longer needed
drop role if exists anon;

-- Drop the graphql function
DROP FUNCTION IF EXISTS graphql;

-- Drop the pg_graphql extension
DROP EXTENSION IF EXISTS pg_graphql; 


-- Remove migration record
DELETE FROM migrations.migration_history WHERE version = '4.1.0'; 

COMMIT;  -- End transaction