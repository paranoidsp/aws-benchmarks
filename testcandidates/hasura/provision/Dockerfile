FROM hasura/graphql-engine:v1.0.0-alpha0

CMD graphql-engine \
    --database-url $(cat ~/postgres_credentials) \
    serve \
    --server-port 8080 \
    --cors-domain "http://localhost:9695"
