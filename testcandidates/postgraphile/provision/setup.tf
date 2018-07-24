
resource "aws_security_group" "graphql_bench" {
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
    from_port = 8050
    to_port = 8050
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

resource "aws_db_instance" "postgraphile_postgres_rds" {
  skip_final_snapshot        = true
  allocated_storage          = 10
  storage_type               = "gp2"
  engine                     = "postgres"
  engine_version             = "10.3"
  name                       = "chinook"
  instance_class             = "db.m3.xlarge"
  username                   = "postgres"
  password                   = "unsecured"
  port                       = "5432"
  parameter_group_name       = "postgres10-benchmark"
  vpc_security_group_ids     = ["${aws_security_group.graphql_bench.id}"]
  backup_retention_period    = 0
  auto_minor_version_upgrade = false
  multi_az                   = false
  storage_encrypted          = false
}

resource "aws_instance" "postgraphile" {
  depends_on                  = ["aws_db_instance.postgraphile_postgres_rds"]
  ami                         = "ami-d491ceac"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  tags {
    Name = "postgraphile"
  }
  user_data                   = "${file("base.sh")}"

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgraphile_postgres_rds.username}:${aws_db_instance.postgraphile_postgres_rds.password}@${aws_db_instance.postgraphile_postgres_rds.address}:${aws_db_instance.postgraphile_postgres_rds.port}/${aws_db_instance.postgraphile_postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
			"sudo chmod +x ~ubuntu/aws-benchmarks/testcandidates/postgraphile/provision/test.sh",
			"sudo chmod +x ~ubuntu/aws-benchmarks/scripts/get_ram.sh",
			"./get_ram.sh 7200 > ~/aws-benchmarks/results/hasura.ram &",
      "~ubuntu/aws-benchmarks/testcandidates/postgraphile/provision/test.sh"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}

resource "aws_instance" "postgraphile_benchmarker" {
  depends_on                  = ["aws_instance.postgraphile"]
  ami                         = "ami-d491ceac"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("base.sh")}"
  tags {
    Name = "postgraphile_benchmarker"
  }

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgraphile_postgres_rds.username}:${aws_db_instance.postgraphile_postgres_rds.password}@${aws_db_instance.postgraphile_postgres_rds.address}:${aws_db_instance.postgraphile_postgres_rds.port}/${aws_db_instance.postgraphile_postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
      "sed -i.bak 's/url: \\(.*\\)$/url: https:\\/\\/\\${aws_instance.postgraphile.public_dns}:8080\\/graphql/' ~/aws_benchmarks/testcandidates/postgraphile/provision/bench.yaml",
      "sleep 100 && cat bench.yaml | docker run -i --rm -p 8050:8050 -v $(pwd):/graphql-bench/ws postgraphile/graphql-bench:v0.3-warmup"
    ]

    connection {
      user = "ec2-user"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}
