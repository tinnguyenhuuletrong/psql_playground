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
DROP TRIGGER IF EXISTS update_users_updated_at ON "public".users;

-- Drop trigger function
DROP FUNCTION IF EXISTS "public".update_updated_at_column();

-- Drop table
DROP TABLE IF EXISTS "public".users;

-- Drop enum type
DROP TYPE IF EXISTS "public".user_role;


-- Remove migration record
DELETE FROM migrations.migration_history WHERE version = '2.1.0'; 

COMMIT;  -- End transaction