#!/bin/bash

cd ~ubuntu/aws-benchmarks/testcandidates/prisma/provision

export DATABASE_URL=$(cat ~/postgres_credentials)

sleep 10

PRISMA=~/prisma/node_modules/prisma/dist/index.js

docker-compose -f docker-compose-pg.yaml up -d
sleep 30

"$PRISMA" deploy
"$PRISMA" import --data postgres/latest.dump
