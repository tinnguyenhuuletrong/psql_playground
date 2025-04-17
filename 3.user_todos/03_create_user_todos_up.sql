BEGIN;  -- Start transaction

-- Check if migration already exists
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '3.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 3.1.0 already exists in migration_history';
    END IF;
END $$;


-- Create user_todos table in public schema
CREATE TABLE IF NOT EXISTS public.user_todos (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on user_id for better query performance
CREATE INDEX idx_user_todos_user_id ON public.user_todos(user_id);

-- Add comment to the table
COMMENT ON TABLE public.user_todos IS 'Stores todo items for users';

-- Create trigger for updated_at
CREATE TRIGGER update_user_todos_updated_at
    BEFORE UPDATE ON "public".user_todos
    FOR EACH ROW
    EXECUTE FUNCTION "public".update_updated_at_column();

-- Track this migration
SELECT migrations.track_migration(
    '3.1.0',
    'user_todos',
    'sha256_hash_of_this_file', -- Placeholder It is going to be replaced with actual checksum when sh script run
    0
); 

COMMIT;  -- End transaction