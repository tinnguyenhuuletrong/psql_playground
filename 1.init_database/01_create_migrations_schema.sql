-- Create migrations schema
CREATE SCHEMA IF NOT EXISTS migrations;

-- Create migrations table
CREATE TABLE IF NOT EXISTS migrations.migration_history (
    id SERIAL PRIMARY KEY,
    version VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    checksum VARCHAR(64) NOT NULL,
    execution_time INTEGER,
    status VARCHAR(20) NOT NULL DEFAULT 'success',
    error_message TEXT,
    UNIQUE(version)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_migration_history_version 
ON migrations.migration_history(version);

-- Create function to track migration execution
CREATE OR REPLACE FUNCTION migrations.track_migration(
    p_version VARCHAR,
    p_name VARCHAR,
    p_checksum VARCHAR,
    p_execution_time INTEGER,
    p_status VARCHAR DEFAULT 'success',
    p_error_message TEXT DEFAULT NULL
) RETURNS void AS $$
BEGIN
    INSERT INTO migrations.migration_history (
        version,
        name,
        checksum,
        execution_time,
        status,
        error_message
    ) VALUES (
        p_version,
        p_name,
        p_checksum,
        p_execution_time,
        p_status,
        p_error_message
    );
END;
$$ LANGUAGE plpgsql; 