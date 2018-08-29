#!/bin/sh

getMachineDNS () {
    cat terraform.tfstate | jq -r ".modules[].resources.\"aws_instance.$1\".primary.attributes.public_dns"
}

cd provision
terraform init

echo "======================="
echo "Finished Initialization"
if [[ $1 == "destroy" ]]
then
  terraform destroy --auto-approve
fi
echo "Applying config"
terraform apply --auto-approve
echo "Finished applying "

benchmarker=$(getMachineDNS "prisma_benchmarker")

ssh -i ~/.ssh/aws-bench.pem ubuntu@$benchmarker "cd ~ubuntu/aws-benchmarks/testcandidates/prisma && cat ../bench.yaml | docker run --name benchmarker -i --rm -p 8050:8050 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.4-variable &"
