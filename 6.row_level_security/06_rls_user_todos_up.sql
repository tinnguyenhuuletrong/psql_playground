BEGIN;  -- Start transaction

-- Check if migration already exists
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '6.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 6.1.0 already exists in migration_history';
    END IF;
END $$;

-- Enable row level security on user_todos table
ALTER TABLE public.user_todos ENABLE ROW LEVEL SECURITY;

-- Create policy for non-admin users (can only see their own todos)
CREATE POLICY user_todos_user_policy 
    ON public.user_todos
    FOR ALL
    TO PUBLIC
    USING (user_id = (SELECT id FROM public.users WHERE id = current_setting('request.jwt.claims.user_id')::uuid))
    WITH CHECK (user_id = (SELECT id FROM public.users WHERE id = current_setting('request.jwt.claims.user_id')::uuid));

-- Create policy for admin users (can see all todos)
CREATE POLICY user_todos_admin_policy 
    ON public.user_todos
    FOR ALL
    TO PUBLIC
    USING ((SELECT role FROM public.users WHERE id = current_setting('request.jwt.claims.user_id')::uuid) = 'admin')
    WITH CHECK ((SELECT role FROM public.users WHERE id = current_setting('request.jwt.claims.user_id')::uuid) = 'admin');

-- Track this migration
SELECT migrations.track_migration(
    '6.1.0',
    'rls_user_todos',
    'sha256_hash_of_this_file', -- Placeholder It is going to be replaced with actual checksum when sh script run
    0
); 

COMMIT;  -- End transaction 