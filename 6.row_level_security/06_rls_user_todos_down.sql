BEGIN;  -- Start transaction

-- Check if migration exists before running down migration
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '6.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 6.1.0 does not exist in migration_history';
    END IF;
END $$;

-- Drop row level security policies
DROP POLICY IF EXISTS user_todos_user_policy ON public.user_todos;
DROP POLICY IF EXISTS user_todos_admin_policy ON public.user_todos;

-- Disable row level security on user_todos table
ALTER TABLE public.user_todos DISABLE ROW LEVEL SECURITY;

-- Remove migration record
DELETE FROM migrations.migration_history WHERE version = '6.1.0';

COMMIT;  -- End transaction 