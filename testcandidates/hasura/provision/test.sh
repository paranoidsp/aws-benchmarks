#!/bin/bash

# Start graphql-engine
echo "Starting graphql-engine"
sed -i.bak "s/--database-url.*$/--database-url $(cat ~/postgres_credentials)/" Dockerfile
docker build . -t hasura/graphql-engine-run:latest
docker run -d hasura/graphql-engine-run:latest -p 8080:8080
touch ~/started_docker
