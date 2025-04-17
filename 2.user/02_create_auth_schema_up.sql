BEGIN;  -- Start transaction

-- Check if migration already exists
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM migrations.migration_history 
        WHERE version = '2.1.0'
    ) THEN
        RAISE EXCEPTION 'Migration version 2.1.0 already exists in migration_history';
    END IF;
END $$;

-- Create user role enum
CREATE TYPE "public".user_role AS ENUM ('user', 'admin');

-- Create user table
CREATE TABLE "public".users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    password VARCHAR(64) NOT NULL, -- SHA256 hash is 64 characters
    role "public".user_role NOT NULL DEFAULT 'user',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index on name for faster lookups
CREATE INDEX idx_users_name ON "public".users(name);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION "public".update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON "public".users
    FOR EACH ROW
    EXECUTE FUNCTION "public".update_updated_at_column();

-- Track this migration
SELECT migrations.track_migration(
    '2.1.0',
    'create_auth_schema',
    'sha256_hash_of_this_file', -- Placeholder It is going to be replaced with actual checksum when sh script run
    0
); 

COMMIT;  -- End transaction