#!/bin/bash
cd ~ubuntu/aws-benchmarks/testcandidates/prisma/provision

PRISMA=~/prisma/node_modules/prisma/dist/index.js

"$PRISMA" import --data postgres/chinook.zip
