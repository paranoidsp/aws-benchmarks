
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

resource "aws_instance" "t2-micro-1" {
  depends_on                  = ["aws_db_instance.postgres_rds"]
  ami                         = "ami-84633afc"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  tags {
    Name = "hasura-t2-micro-1",
		CPU  = "1"
  }
  user_data                   = "${file("base.sh")}"

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
			"sudo chmod +x ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh",
			"sudo chmod +x ~ubuntu/aws-benchmarks/scripts/get_ram.sh",
			"./get_ram.sh 10800 > ~/aws-benchmarks/testcandidates/hasura/hasura.ram &",
      "~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh 1"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}

resource "aws_instance" "t2-medium-2" {
  depends_on                  = ["aws_db_instance.postgres_rds"]
  ami                         = "ami-84633afc"
  instance_type               = "t2.medium"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  tags {
    Name = "hasura-t2-medium-2",
		CPU  = "2"
  }
  user_data                   = "${file("base.sh")}"

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
			"sudo chmod +x ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh",
			"sudo chmod +x ~ubuntu/aws-benchmarks/scripts/get_ram.sh",
			"./get_ram.sh 10800 > ~/aws-benchmarks/testcandidates/hasura/hasura.ram &",
      "~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh 2"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}

resource "aws_instance" "m5-xlarge-4" {
  depends_on                  = ["aws_db_instance.postgres_rds"]
  ami                         = "ami-84633afc"
  instance_type               = "m5.xlarge"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  tags {
    Name = "hasura-m5-xlarge-4",
		CPU  = "4"
  }
  user_data                   = "${file("base.sh")}"

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
			"sudo chmod +x ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh",
			"sudo chmod +x ~ubuntu/aws-benchmarks/scripts/get_ram.sh",
			"./get_ram.sh 10800 > ~/aws-benchmarks/testcandidates/hasura/hasura.ram &",
      "~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh 4"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}

resource "aws_instance" "m5-2xlarge-8" {
  depends_on                  = ["aws_db_instance.postgres_rds"]
  ami                         = "ami-84633afc"
  instance_type               = "m5.2xlarge"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  tags {
    Name = "hasura-m5-2xlarge-8",
		CPU  = "8"
  }
  user_data                   = "${file("base.sh")}"

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
			"sudo chmod +x ~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh",
			"sudo chmod +x ~ubuntu/aws-benchmarks/scripts/get_ram.sh",
			"./get_ram.sh 10800 > ~/aws-benchmarks/testcandidates/hasura/hasura.ram &",
      "~ubuntu/aws-benchmarks/testcandidates/hasura/provision/test.sh 8"
    ]
    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}

resource "aws_instance" "hasura_benchmarker" {
  depends_on                  = ["aws_instance.t2-micro-1"]
  depends_on                  = ["aws_instance.t2-medium-2"]
  depends_on                  = ["aws_instance.m5-xlarge-4"]
  depends_on                  = ["aws_instance.m5-2xlarge-8"]
  ami                         = "ami-84633afc"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  key_name                    = "aws-bench"
  vpc_security_group_ids      = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("base.sh")}"
  tags {
    Name = "hasura_benchmarker"
  }

  provisioner "remote-exec" {
    inline = [
      "echo -n postgres://${aws_db_instance.postgres_rds.username}:${aws_db_instance.postgres_rds.password}@${aws_db_instance.postgres_rds.address}:${aws_db_instance.postgres_rds.port}/${aws_db_instance.postgres_rds.name} > ~/postgres_credentials",
			"sleep 100",
			"sudo chown ubuntu:ubuntu -R ~/aws-benchmarks",
      "sed -i.bak 's/url1: \\(.*\\)$/url: http:\\/\\/\\${aws_instance.t2-micro-1.public_dns}:8080\\/v1alpha1\\/graphql/' ~/aws-benchmarks/testcandidates/bench.yaml",
      "sed -i.bak 's/url2: \\(.*\\)$/url: http:\\/\\/\\${aws_instance.t2-medium-2.public_dns}:8080\\/v1alpha1\\/graphql/' ~/aws-benchmarks/testcandidates/bench.yaml",
      "sed -i.bak 's/url3: \\(.*\\)$/url: http:\\/\\/\\${aws_instance.m5-xlarge-4.public_dns}:8080\\/v1alpha1\\/graphql/' ~/aws-benchmarks/testcandidates/bench.yaml",
      "sed -i.bak 's/url4: \\(.*\\)$/url: http:\\/\\/\\${aws_instance.m5-2xlarge-8.public_dns}:8080\\/v1alpha1\\/graphql/' ~/aws-benchmarks/testcandidates/bench.yaml",
      "sudo chmod +x ~ubuntu/testcandidates/hasura/provision/bench.sh",
      "~ubuntu/testcandidates/hasura/provision/bench.sh &"
    ]


    connection {
      user = "ubuntu"
      private_key = "${file("~/.ssh/aws-bench.pem")}"
    }
  }
}
