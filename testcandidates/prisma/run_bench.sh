#!/bin/sh

getMachineDNS () {
    cat terraform.tfstate | jq -r ".modules[].resources.\"aws_instance.$1\".primary.attributes.public_dns"
}

cd provision
terraform init
terraform destroy --auto-approve
terraform apply --auto-approve

benchmarker=$(getMachineDns "prisma_benchmarker")

ssh -i ~/.ssh/aws-bench.pem ubuntu@$benchmarker "cd ~ubuntu/aws-benchmarks/testcandidates/hasura && cat ../bench.yaml | docker run --name benchmarker -i --rm -p 8050:8050 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.3-warmup"
