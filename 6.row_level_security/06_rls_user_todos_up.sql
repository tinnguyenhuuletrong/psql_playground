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

-- Function to retrieve the current user's UUID from the JWT claims
CREATE FUNCTION "session_user_uuid"()
  RETURNS TEXT
  IMMUTABLE
  LANGUAGE SQL
AS $$ 
    SELECT NULLIF(current_setting('request.jwt.claims', true)::JSON->>'user_id', '');
$$;

-- Enable row level security on the user_todos table
ALTER TABLE public.user_todos ENABLE ROW LEVEL SECURITY;

-- Policy for non-admin users to only see their own todos
CREATE POLICY user_todos_user_policy 
    ON public.user_todos
    FOR ALL
    TO PUBLIC
    USING (user_id = (SELECT id FROM public.users WHERE id = public.session_user_uuid()::uuid))
    WITH CHECK (user_id = (SELECT id FROM public.users WHERE id = public.session_user_uuid()::uuid));

-- Policy for admin users to see all todos
CREATE POLICY user_todos_admin_policy 
    ON public.user_todos
    FOR ALL
    TO PUBLIC
    USING ((SELECT role FROM public.users WHERE id = public.session_user_uuid()::uuid) = 'admin')
    WITH CHECK ((SELECT role FROM public.users WHERE id = public.session_user_uuid()::uuid) = 'admin');

-- Track this migration
SELECT migrations.track_migration(
    '6.1.0',
    'rls_user_todos',
    'sha256_hash_of_this_file', -- Placeholder for actual checksum
    0
); 

COMMIT;  -- End transaction 