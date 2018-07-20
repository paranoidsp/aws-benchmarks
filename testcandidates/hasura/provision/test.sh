#!/bin/bash

# Install git and clone repo
sudo yum install -y git
touch ~/installed_git
cd ~
git clone https://github.com/paranoidsp/aws-benchmarks.git ~/aws-benchmarks

# Setup rds
cd ~/aws-benchmarks/testcandidates/hasura
  # copy it into the container
  docker cp "$SCRIPT_DIR/chinook.data" postgres-chinook:/chinook.data
  # import the data
  docker exec postgres-chinook pg_restore -h 127.0.0.1 -p 5432 -U admin -d chinook /chinook.data

  # initialise raven
  docker run --rm hasuraci/raven:de42ddb raven --host 172.17.0.1 -p 7432 -u admin -p '' -d chinook initialise

  # start raven
  docker run --name raven-chinook -p 7080:8080 -d hasuraci/raven:de42ddb raven --host 172.17.0.1 -p 7432 -u admin -p '' -d chinook serve --connections 100

  # wait for raven to come up
  sleep 5

  # add raven metadata
  cat "$SCRIPT_DIR/metadata.json" | curl -d @- -XPOST -H 'X-Hasura-User-Id:0' -H 'X-Hasura-Role:admin' $RAVEN_URL/v1/query

# Start graphql server
./manage.sh start
