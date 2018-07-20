FROM hasura/graphql-engine:v1.0.0-alpha08

ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

CMD graphql-engine \
    --database-url $DATABASE_URL \
    serve \
    --server-port 8080 \
    --cors-domain "http://localhost:9695"
