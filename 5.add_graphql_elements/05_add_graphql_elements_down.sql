BEGIN;
-- Start transaction

-- Remove the function to query user info
DROP FUNCTION IF EXISTS public.addNums();
-- Remove the function

-- Remove migration record
DELETE FROM migrations.migration_history
WHERE version = '5.1.0';
-- Remove the migration record
COMMIT;
-- End transaction