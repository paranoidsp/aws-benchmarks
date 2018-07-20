#!/bin/bash

# Start graphql-engine
echo "Starting graphql-engine"
cd ~ec2-user/aws-benchmarks/testcandidates/hasura/provision
export DATABASE_URL=$(cat ~/postgres_credentials); docker build --build-arg "DATABASE_URL=$DATABASE_URL" . -t hasura/graphql-engine-run:latest
docker run -p 8080:8080 -e "DATABASE_URL=$DATABASE_URL" -d hasura/graphql-engine-run:latest
touch ~/started_docker
