# terraform/outputs.tf
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ansible_target.public_ip
}