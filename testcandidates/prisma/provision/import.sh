#!/bin/bash
PRISMA=~/prisma/node_modules/prisma/dist/index.js
"$PRISMA" import --data postgres/chinook.zip
