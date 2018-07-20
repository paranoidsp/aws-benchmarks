
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

resource "aws_db_instance" "postgres_rds" {
  skip_final_snapshot        = true
  allocated_storage          = 10
  storage_type               = "gp2"
  engine                     = "postgres"
  engine_version             = "10.3"
  name                       = "chinook"
  instance_class             = "db.m3.xlarge"
  username                   = "hasura"
  password                   = "unsecured"
  port                       = "5432"
  parameter_group_name       = "postgres10-benchmark"
  vpc_security_group_ids     = ["${aws_security_group.graphql_bench.id}"]
  backup_retention_period    = 0
  auto_minor_version_upgrade = false
  multi_az                   = false
  storage_encrypted          = false
}

resource "aws_instance" "hasura_graphql_engine" {
  depends_on                  = ["aws_db_instance.postgres_rds"]
  ami                         = "ami-d2f489aa"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("test.sh")}"
  tags {
    Name = "hasura_graphql_engine"
  }

  provisioner "local-exec" {
    command = "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials"
  }

  provisioner "local-exec" {
    command = "./graphql-server.sh start" 
  }
}

resource "aws_instance" "hasura_benchmarker" {
  depends_on                  = ["aws_instance.hasura_graphql_engine"]
  ami                         = "ami-d2f489aa"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("benchmarker.sh")}"
  tags {
    Name = "hasura_benchmarker"
  }

  provisioner "local-exec" {
    command = "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials"
  }

  provisioner "local-exec" {
    command = "sed -i.bak 's/url: \\(.*\\)$/url: https:\\/\\/\\${aws_instance.hasura_graphql_engine.public_dns}:8080\\/v1alpha1\\/graphql/' ~/aws_benchmarks/testcandidates/hasura/bench.yaml"
  }

  provisioner "local-exec" {
    command = "sleep 100 && cat bench.yaml | docker run -i --rm -p 8050:8050 -v $(pwd):/graphql-bench/ws hasura/graphql-bench:v0.3"
  }
}

