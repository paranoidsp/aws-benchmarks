
resource "aws_security_group" "graphql_bench" {
  name = "graphql_bench"
  description = "Benchmarking group"
 
  tags {
    Name = "allow_ssh"
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_instance" "hasura_postgres_rds" {
  name                 = "hasura_postgres_rds"
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgresql"
  engine_version       = "10.3"
  database_name        = "chinook"
  instance_class       = "db.m3.xlarge"
  username             = "admin"
  password             = "unsecured"
  port                 = "5432"
  parameter_group_name = "postgres10-benchmark"
  vpc_security_group_ids = ["${data.aws_security_group.graphql_bench.id}"]
  backup_retention_period = 0
  auto_minor_version_upgrade = false
  multi_availability_zone = false
  storage_encrypted = false
}

resource "aws_instance" "hasura_graphql_engine" {
  ami = "ami-d2f489aa"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "aws-bench"
  tags {
    Name = "hasura_graphql_engine"
  }
  vpc_security_group_ids = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data = "${file("provision/test.sh")}"
}

resource "aws_instance" "hasura_benchmarker" {
  ami = "ami-d2f489aa"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "aws-bench"
  tags {
    Name = "hasura_benchmarker"
  }
  vpc_security_group_ids = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data = "${file("provision/benchmarker.sh")}"
}

