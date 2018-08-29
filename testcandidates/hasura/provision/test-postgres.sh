#!/bin/bash

# Start graphql-engine

cpus=$1

cd ~ubuntu/aws-benchmarks/testcandidates/hasura/provision

export DATABASE_URL=$(cat ~/postgres_credentials)

sleep 10

# Restore postgres

pg_restore --clean --no-acl --no-owner -d "$(cat ~/postgres_credentials)" ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/postgres/chinook.dump
sleep 10

nohup ~ubuntu/aws-benchmarks/get_ram.sh 10800 > ~ubuntu/hasura.ram &

docker run --name graphql-engine -p 8080:8080  -d hasura/graphql-engine:dev-rtsopts-n-e924d3e graphql-engine +RTS -N -RTS --database-url "$(cat ~/postgres_credentials)" serve --cors-domain "https://localhost:9695" --server-port 8080 --enable-console -s $cpus -c 50
cat postgres/metadata.json | curl -d @- -X POST -i http://localhost:8080/v1/query
touch ~/started_docker
