#!/usr/bin/env sh

set -e

SCRIPT_DIR=$(dirname "$0")

DEFAULT_RAVEN_URL="http://127.0.0.1:7080"

RAVEN_URL=${RAVEN_URL:-$DEFAULT_RAVEN_URL}

usage() {
    echo "Usage: $0 (init|start|nuke)"
}

init () {

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
}

start () {
    # start postgres
    docker start postgres-chinook
    # wait for postgres to come up
    sleep 5
    # start raven
    docker start raven-chinook
}

stop () {
    echo 'stopping raven-chinook container'
    docker stop raven-chinook
    echo 'stopping postgres-chinook container'
    docker stop postgres-chinook
}

nuke () {
    echo 'removing raven-chinook container'
    docker stop raven-chinook && docker rm raven-chinook
    echo 'removing postgres-chinook container'
    docker stop postgres-chinook && docker rm postgres-chinook
    echo 'removing postgres-chinook volume'
    docker volume rm postgres-chinook
}

if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

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
