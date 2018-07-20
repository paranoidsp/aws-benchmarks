#!/bin/bash

sudo su ec2-user
sudo yum install -y git
touch ~/installed_git
cd ~
git clone https://github.com/paranoidsp/aws-benchmarks.git ~/aws-benchmarks


# Set up benchmarking and postgres
cd ~/aws-benchmarks/testcandidates/hasura
hostname=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
sed -i.bak "s/url: \(.*\)$/url: https:\/\/$hostname\/v1alpha1\/graphql/" bench.yaml

query_url="https://$hostname/v1/query"

curl -Lo chinook.data https://github.com/paranoidsp/aws-benchmarks/raw/master/testcandidates/hasura/provision/postgres/chinook.data
pg_restore -d `cat ~/postgres_credentials` chinook.data

touch ~/3-restored_data

cat "provision/postgres/metadata.json" | curl -d @- -XPOST -H 'X-Hasura-User-Id:0' -H 'X-Hasura-Role:admin' $RAVEN_URL/v1/query

cat bench.yaml | docker run -d --rm -p 8080:8080 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.3
