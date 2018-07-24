#!/bin/bash

# Start graphql-engine

echo "Starting graphql-engine"

cd ~ubuntu/aws-benchmarks/testcandidates/hasura/provision


export DATABASE_URL=$(cat ~/postgres_credentials); docker build --build-arg "DATABASE_URL=$DATABASE_URL" . -t hasura/graphql-engine-run:latest

sleep 10

# Restore postgres

pg_restore --clean --no-acl --no-owner -d 'postgres://postgres:unsecured@localhost:7432/chinook' ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/postgres/chinook.dump
sleep 10

docker run --name graphql-engine -p 8080:8080  -d hasura/graphql-engine-run:latest --database-url "$(cat ~/postgres_credentials)" serve --cors-domain "https://localhost:9695" --server-port 8080 --enable-console 
touch ~/started_docker
