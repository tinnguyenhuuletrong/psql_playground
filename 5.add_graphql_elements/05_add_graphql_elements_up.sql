BEGIN;
-- Start transaction
-- Check if migration already exists
DO $$ BEGIN IF EXISTS (
    SELECT 1
    FROM migrations.migration_history
    WHERE version = '5.1.0'
) THEN RAISE EXCEPTION 'Migration version 5.1.0 already exists in migration_history';
END IF;
END $$;

create function "addNums"(a int, b int)
  returns int
  immutable
  language sql
as $$ select a + b; $$;


-- Track this migration
SELECT migrations.track_migration(
        '5.1.0',
        'add_graphql',
        'sha256_hash_of_this_file',
        -- Placeholder for actual checksum
        0
    );
COMMIT;
-- End transaction