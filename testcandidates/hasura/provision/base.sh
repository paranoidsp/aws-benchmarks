#!/bin/bash

# Install git and clone repo
sudo apt update
sudo apt -y install git postgresql10 docker
touch ~ubuntu/installed_git
cd ~
git clone https://github.com/paranoidsp/aws-benchmarks.git ~ubuntu/aws-benchmarks
cd ~ubuntu/aws-benchmarks/testcandidates/hasura/provision
