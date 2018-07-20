#!/bin/bash

# Start graphql-engine
echo "Starting graphql-engine"
cd ~ec2-user/aws-benchmarks/testcandidates/hasura/provision
docker build . -t hasura/graphql-engine-run:latest
docker run -p 8080:8080 -d hasura/graphql-engine-run:latest
touch ~/started_docker
