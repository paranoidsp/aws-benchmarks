#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

DEFAULT_RAVEN_URL="http://127.0.0.1:7080"

RAVEN_URL=${RAVEN_URL:-$DEFAULT_RAVEN_URL}

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

start () {
  cd ~/aws_benchmarks/testcandidates/hasura/provision
  sed -i.bak "s/--database-url.*$/--database-url $(cat ~/postgres_credentials)/" Dockerfile
  docker build . -t hasura/graphql-engine-run:latest
  docker run -d hasura/graphql-engine-run:latest -p 8080:8080
  touch ~/started_docker
}

case $1 in
    init)
        init
        exit
        ;;
    start)
        start
        exit
        ;;
    stop)
        stop
        exit
        ;;
    nuke)
        nuke
        exit
        ;;
    *)
        echo "unexpected option: $1"
        usage
        exit 1
        ;;
esac
