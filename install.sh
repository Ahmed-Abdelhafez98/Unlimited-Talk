#!/bin/bash

echo "Building Docker containers..."
docker-compose build

echo "Starting Docker containers..."
docker-compose up -d

echo "Waiting for database to be ready..."
sleep 30

echo "Create database..."
docker-compose exec app rails db:create

echo "Running database migrations..."
docker-compose exec app rails db:migrate

echo "Seeding database..."
docker-compose exec app rails db:seed

echo "Reindexing Elasticsearch..."
docker-compose exec app rake es:reindex_messages

echo "Running RSpec tests..."
docker-compose exec app bundle exec rspec

echo "Installation and setup completed successfully!"