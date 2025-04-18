#!/bin/bash

# Step 1: Navigate to 1.init_database and run migration
pushd ../1.init_database || exit
sh ./run_migration.sh up
popd  # Return to the previous directory

# Step 2: Navigate to 2.user and run migrations and seeding
pushd ../2.user || exit
sh ./run_migration.sh up && sh ./run_migration.sh seed
popd  # Return to the previous directory

# Step 3: Navigate to 3.user_todos and run migrations and seeding
pushd ../3.user_todos || exit
sh ./run_migration.sh up && sh ./run_migration.sh seed
popd  # Return to the previous directory

# Step 4: Navigate to 4.add_graphql and run migrations
pushd ../4.add_graphql || exit
sh ./run_migration.sh up

# Step 5: Navigate to 5.add_graphql_elements and run migrations
pushd ../5.add_graphql_elements || exit
sh ./run_migration.sh up

# Step 6: Navigate to 6.row_level_security and run migrations
pushd ../6.row_level_security || exit
sh ./run_migration.sh up

# restart pg_postgrest - affect the schema permission
docker restart pg_postgrest

popd  # Return to the previous directory
