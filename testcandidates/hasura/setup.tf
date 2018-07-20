
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

resource "aws_instance" "hasura_postgres" {
  ami = "ami-d2f489aa"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "aws-bench"
  tags {
    Name = "hasura_postgres"
  }
  vpc_security_group_ids = ["${aws_security_group.graphql_bench.id}"]
  associate_public_ip_address = true
  user_data = "${file("../ssh-keys.sh")}"
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
  user_data = "${file("../ssh-keys.sh")}"
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
  user_data = "${file("../ssh-keys.sh")}"
}
