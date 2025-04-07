
-- Drop trigger function
DROP FUNCTION IF EXISTS "migrations".track_migration;

-- Drop table
DROP TABLE IF EXISTS "migrations".migration_history;

-- Drop schema
DROP SCHEMA IF EXISTS "migrations";
