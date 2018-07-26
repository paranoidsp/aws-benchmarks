#!/bin/bash

# Start graphql-engine

cpus=$1

cd ~ubuntu/aws-benchmarks/testcandidates/hasura/provision

export DATABASE_URL=$(cat ~/postgres_credentials); docker build . -t hasura/graphql-engine-run:latest

sleep 10

# Restore postgres

pg_restore --clean --no-acl --no-owner -d "$(cat ~/postgres_credentials)" ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/postgres/chinook.dump
sleep 10

docker run --name graphql-engine -p 8080:8080  -d hasura/graphql-engine-run:latest graphql-engine --database-url "$(cat ~/postgres_credentials)" serve --cors-domain "https://localhost:9695" --server-port 8080 --enable-console -s $cpus -c 500
cat postgres/metadata.json | curl -d @- -X POST -i http://localhost:8080/v1/query
touch ~/started_docker
