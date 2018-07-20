FROM hasura/graphql-engine:v1.0.0-alpha0

CMD graphql-engine \
    --database-url $DATABASE_URL \
    serve \
    --server-port $PORT \
    --cors-domain "http://localhost:9695"
