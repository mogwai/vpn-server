provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_key_pair" "admin" {
  key_name   = "himion0@gmail.com"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzSU7lC8YJ/Y8AxgTT/PJSgyCoP8TRFEAGtTzLi51PQSFcidrAgVeVarh75yvy4MLIOEfPQWjjlvyGvTyWIIUstVYzFcdFbylQJwNgnjaRkyeXNGK0QpNn9nDnS08SKG1G6hywIcNTSYIJzMoe6L0FvU22Jt0x1NZSuozc7TFMrn7dOjQVMM/Jcz83NzNrEr6OAFp67ZpLwErY99LisqMHPMVTfmtYKdXcTROP61W0KhsOfgfsS7uRJZNIb5kxxDZgdaYpRnu/mdgfXSjxN0NveJQeiEs55E9LjVoTQjpo9w5H0NuIUYSU5Y5V9d73XyKXu+wGK1CfFTAh5fAdojHGilRN4+kkQOyUfffAz6xfHktAkqRbT6hyJFwVT2tbWrnT4wKqlMlOaRAw9K9wC02bEySwDnndzRNVw+E2dIVEAE3z2+X3SvzdMycbPT/1+alVNp4rQt0WBLjEha6Of3glilh7AiRdLDMnrf2Qq8+2VmVXI/WFm9FstNL9UiWWVMIP0/bVaOTQ9NqQo3LDW0c1ZqBZH3hccywByOcuCXrEe1zTxJ1OAyOTTtcDIoFaUUe0sqmbfXC8zINp+r7n3lY3LZWiPSyCzM/lHV1nLOlMhl7h3/qm8d38EVYy0/Qj3D0Ain974E6aRHRJ8B1ax562t5H0AzEorBfXpxydNmv2gw== himion0@gmail.com"
}

resource "aws_security_group" "allow_vpn" {
  name        = "vpn"
  description = "VPN"

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "vpn_ip" {
  tags = {
    Name = "vpn_server_ip"
  }
  instance = aws_instance.vpn_proxy.id
}

resource "aws_instance" "vpn_proxy" {
  ami           = "ami-01e6a0b85de033c99"
  instance_type = "t2.micro"

  tags = {
    Name = "vpn_proxy"
  }

  key_name = aws_key_pair.admin.key_name

  security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_vpn.name]

  depends_on = [aws_key_pair.admin, aws_security_group.allow_ssh]

    provisioner "local-exec" {
        command = <<EOH
        sudo apt-get update
        sudo apt install python
        EOH
  }
}

output "ip" {
  value = aws_eip.vpn_ip.public_ip
}