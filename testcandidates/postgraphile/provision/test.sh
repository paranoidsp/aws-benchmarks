#!/bin/bash

cd ~ubuntu/aws-benchmarks/testcandidates/postgraphile/provision

export DATABASE_URL=$(cat ~/postgres_credentials)
docker build . -t hasura/postgraphile:latest

sleep 10

# Restore postgres
pg_restore --clean --no-acl --no-owner -d "$DATABASE_URL" ~ubuntu/aws-benchmarks/testcandidates/postgraphile/provision/postgres/chinook.dump
sleep 10


docker run --name postgraphile-chinook -p 8080:8080 -d hasura/postgraphile:latest postgraphile -c "$DATABASE_URL" --host 0.0.0.0 --max-pool-size 100 --cluster-workers "$N_CPUS" -p 8080
touch ~/started_docker
