#!/bin/bash

cd ~ubuntu/aws-benchmarks/testcandidates/postgraphile/provision

export DATABASE_URL=$(cat ~/postgres_credentials); docker build . -t hasura/postgraphile:latest

sleep 10

# Restore postgres
echo "Restoring data"
pg_restore --clean --no-acl --no-owner -d 'postgres://postgres:unsecured@localhost:7432/chinook' postgres/chinook.dump
sleep 10


docker run --name postgraphile-chinook -p 8080:8080 -d hasura/postgraphile:latest postgraphile -c "$DATABASE_URL" --host 0.0.0.0 --max-pool-size 100 --cluster-workers "$N_CPUS"
docker run -p 8080:8080 -e "DATABASE_URL=$DATABASE_URL" -d hasura/graphql-engine-run:latest
touch ~/started_docker
