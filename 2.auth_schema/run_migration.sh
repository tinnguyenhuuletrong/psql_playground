#!/bin/bash

# Database connection details
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="psql_local"
DB_USER="postgres"
DB_PASSWORD="postgres"

# Function to calculate SHA256 hash of a file
calculate_checksum() {
    local file=$1
    sha256sum "$file" | cut -d' ' -f1
}

# Function to run migration
run_migration() {
    local direction=$1
    local file=$2
    
    # Calculate checksum
    local checksum=$(calculate_checksum "$file")
    
    # Replace checksum placeholder in the SQL file
    sed -i "s/sha256_hash_of_this_file/$checksum/" "$file"
    
    # Run the migration
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
    
    echo "Migration $direction completed: $file"
}

# Main execution
case "$1" in
    "up")
        run_migration "up" "01_create_auth_schema_up.sql"
        ;;
    "down")
        run_migration "down" "02_create_auth_schema_down.sql"
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac 