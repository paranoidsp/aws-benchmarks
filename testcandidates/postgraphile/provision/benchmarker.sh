#!/bin/bash

# Set up benchmarking and postgres
cd ~/aws-benchmarks/testcandidates/postgraphile
hostname=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
sed -i.bak "s/url: \(.*\)$/url: https:\/\/$hostname:8080\/graphql/" bench.yaml

cat bench.yaml | docker run -d --rm -p 8080:8080 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.3
