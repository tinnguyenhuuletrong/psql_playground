#!/bin/bash

# Database connection details
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="psql_local"
DB_USER="postgres"
DB_PASSWORD="postgres"


# Function to run migration
run_migration() {
    local direction=$1
    local file=$2
    
    # Run the migration
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
    
    echo "Migration $direction completed: $file"
}

# Main execution
case "$1" in
    "up")
        run_migration "up" "01_create_migrations_schema_up.sql"
        ;;
    "down")
        run_migration "down" "01_create_migrations_schema_down.sql"
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac 