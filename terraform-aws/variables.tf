# terraform/variables.tf
variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1" # Change to your preferred region
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t2.micro" # Free tier eligible
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance (e.g., Amazon Linux 2 or Ubuntu LTS)."
  type        = string
  # Find latest AMI for your region:
  # Amazon Linux 2 (us-east-1): ami-053b0a53597fe097f
  # Ubuntu 22.04 LTS (us-east-1): ami-053b0a53597fe097f (example, verify latest)
  default     = "ami-020cba7c55df1f615" # Example: Amazon Linux 2 AMI for us-east-1. VERIFY THIS FOR YOUR REGION!
}

variable "key_name" {
  description = "The name of the AWS Key Pair to use for SSH access."
  type        = string
  # IMPORTANT: Replace with the name of an existing EC2 Key Pair in your AWS account.
  # This key pair's private key will be needed by Jenkins for Ansible.
  default     = "new_key" # <--- CHANGE THIS TO YOUR KEY PAIR NAME
}