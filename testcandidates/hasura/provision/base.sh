#!/bin/bash

# Install git and clone repo
sudo yum install -y git postgresql
touch ~ec2-user/installed_git
cd ~
git clone https://github.com/paranoidsp/aws-benchmarks.git ~ec2-user/aws-benchmarks
cd ~ec2-user/aws-benchmarks/testcandidates/hasura/provision
