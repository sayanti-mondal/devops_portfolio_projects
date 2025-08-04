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
              
              EOF

  tags = {
    Name = "Jenkins-Ansible-Target"
  }
}
