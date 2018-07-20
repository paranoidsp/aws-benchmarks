#!/bin/bash

# Install git and clone repo
sudo yum install -y git postgresql
touch ~/installed_git
cd ~
git clone https://github.com/paranoidsp/aws-benchmarks.git ~/aws-benchmarks

