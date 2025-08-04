# terraform/main.tf
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-jenkins-ansible-sg"
  description = "Allow SSH traffic for Ansible"
  vpc_id      = data.aws_vpc.default.id # Assumes a default VPC exists

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: For production, restrict this to specific IPs (e.g., Jenkins server IP)
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: For production, restrict this to specific IPs (e.g., Jenkins server IP)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "JenkinsAnsibleEC2SG"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "ansible_target" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # User data to ensure Python is installed for Ansible
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 # For Amazon Linux 2 / CentOS
              # For Ubuntu, use: apt update -y && apt install -y python3
              echo "Python installed for Ansible."

              # Add Docker's official GPG key:
              sudo apt-get update
              sudo apt-get install ca-certificates curl
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc

              # Add the repository to Apt sources:
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update
              
              EOF

  tags = {
    Name = "Jenkins-Ansible-Target"
  }
}
