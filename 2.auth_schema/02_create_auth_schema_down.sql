BEGIN;  -- Start transaction

-- Check if migration exists before running down migration
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '2.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 2.1.0 does not exist in migration_history';
    END IF;
END $$;

-- Drop trigger first
DROP TRIGGER IF EXISTS update_users_updated_at ON "auth".users;

-- Drop trigger function
DROP FUNCTION IF EXISTS "auth".update_updated_at_column();

-- Drop table
DROP TABLE IF EXISTS "auth".users;

-- Drop enum type
DROP TYPE IF EXISTS "auth".user_role;

-- Drop schema
DROP SCHEMA IF EXISTS "auth";

-- Remove migration record
DELETE FROM migrations.migration_history WHERE version = '2.1.0'; 

COMMIT;  -- End transaction