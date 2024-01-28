output "project-name" {
  description = "Print a Custom Message:"
  value       = "Telerik Academy UpSkill DevOps Project"
}

output "vpc_id" {
  description = "Output the VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_url" {
  description = "Public IRL for our Web Server"
  value       = "http://${aws_instance.web_server.public_ip}:80"
}


output "private_ip" {
  description = "EC2 Private IP Address:"
  value       = aws_instance.web_server.private_ip
}

output "public_ip" {
  description = "Your EC2 Instance Public IP:"
  value       = aws_instance.web_server.public_ip
}
output "vpc_information" {
  description = "VPC Information about Environment"
  value       = "Your ${aws_vpc.vpc.tags.Environment} VPC has an ID of ${aws_vpc.vpc.id}"
}

output "ec2-instance-name" {
  description = "outputs your ec2-instance name"
  value       = aws_instance.web_server.tags.Name
  sensitive   = false
}
