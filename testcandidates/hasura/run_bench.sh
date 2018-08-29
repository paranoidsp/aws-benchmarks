#!/bin/sh

getMachineDNS () {
    cat terraform.tfstate | jq -r ".modules[].resources.\"aws_instance.$1\".primary.attributes.public_dns"
}

cd provision
terraform init

if [[ $1 == "destroy" ]]
then
  terraform destroy --auto-approve
fi
terraform apply --auto-approve

benchmarker=$(getMachineDNS "hasura_benchmarker")

set -x
ssh -i ~/.ssh/aws-bench.pem ubuntu@$benchmarker "cd ~ubuntu/aws-benchmarks/testcandidates/hasura && cat ~ubuntu/aws-benchmarks/testcandidates/bench.yaml | docker run --name benchmarker -i --rm -p 8050:8050 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.3.2 &"
