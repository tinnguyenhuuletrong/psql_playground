BEGIN;  -- Start transaction

-- Check if migration exists before running down migration
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '3.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 3.1.0 does not exist in migration_history';
    END IF;
END $$;

-- Drop the user_todos table and its index
DROP INDEX IF EXISTS public.idx_user_todos_user_id;
DROP TABLE IF EXISTS public.user_todos; 

-- Remove migration record
DELETE FROM migrations.migration_history WHERE version = '3.1.0'; 


COMMIT;  -- End transaction