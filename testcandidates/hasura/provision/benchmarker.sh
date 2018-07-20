#!/bin/bash

mkdir -p /home/ec2-user/.ssh
cat << EOF >> /home/ec2-user/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOiSdDGdZVCHiG+nDRxF3MtPDZoC+JsXZYKQLfN7wzFSNJ2Zd/CIlwgFZz3NPGFNefZV8C5Vfz5EzjYm19KiH7TQNSLgTBK9LaXLLeXJ+o6lZocDuVpH1YiLYdKA5cw9/Bb13FL4jnPlLg7clsVresNYl/AmmaavKbvpVzK/tDBAiQ0MHpqk8ZdHi0d2UJjDeBQ9fvU/3BaIEFSy893nebKVBeHb38aFEOf5gl6jC7lEZ2ZAFpqgZe1iNIx9oKJOFTxCpgvB1xIAfaBv1yVV4G1isIzNS/JADlZwOLl/u150DJ5IqWTGnYhE7wpT2GEd23ZZ6uNWpCW6AVBveUtFMt karthikeya@hasura.io
EOF

chown ec2-user /home/ec2-user/.ssh/authorized_keys
chmod 400 /home/ec2-user/.ssh/authorized_keys
touch ~/added_key

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
