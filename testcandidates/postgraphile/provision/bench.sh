#!/bin/sh
cd ~ubuntu/aws-benchmarks/testcandidates/postgraphile && cat ../bench.yaml | docker run -i --rm -p 8050:8050 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.3-warmup
