output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.testinstance.id
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.testinstance.public_ip
}

output "instance_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.testinstance.public_dns
}
