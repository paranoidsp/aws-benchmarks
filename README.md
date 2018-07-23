
# Usage
-*** Run the bench.sh file.


# Working
- The bench.sh file uses terraform to setup and manage three machines per testcandidate:
  - An Amazon RDS Postgres instance to run postgres
  - An EC2 instance to run the graphql-server
  - An EC2 instance to run the wrk2 attacker

  All these are created on the same vpc and security group.


