#!/bin/bash
set -e

echo "Waiting for database to be ready..."
sleep 5  # Wait for 5 seconds (adjust if needed)

echo "Populating database with mock data..."
bundle exec rails db:seed

echo "Database populated successfully!"

exec "$@"
