#!/bin/bash

# Start graphql-engine

echo "Starting graphql-engine"

cd ~ubuntu/aws-benchmarks/testcandidates/hasura/provision

psql -d $(cat ~/postgres_credentials) -f roles.sql

export DATABASE_URL=$(cat ~/postgres_credentials); docker build --build-arg "DATABASE_URL=$DATABASE_URL" . -t hasura/graphql-engine-run:latest

sleep 10

# Restore postgres
pg_restore -d $DATABASE_URL postgres/chinook.data

sleep 10

cat "$SCRIPT_DIR/metadata.json" | curl -d @- -XPOST -H 'X-Hasura-User-Id:0' -H 'X-Hasura-Role:admin' $RAVEN_URL/v1/query

docker run -p 8080:8080 -e "DATABASE_URL=$DATABASE_URL" -d hasura/graphql-engine-run:latest
touch ~/started_docker
