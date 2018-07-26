#!/bin/bash

cpus=$1

cd ~ubuntu/aws-benchmarks/testcandidates/prisma/provision

export DATABASE_URL=$(cat ~/postgres_credentials)

sleep 10

PRISMA=~/prisma/node_modules/prisma/dist/index.js

nohup ~ubuntu/aws-benchmarks/get_ram.sh 10800 > ~ubuntu/prisma.ram &

docker-compose -f docker-compose-pg.yml up -d
