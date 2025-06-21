# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnet Outputs
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

# Security Group Outputs
output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  description = "The ID of the database security group"
  value       = aws_security_group.db_sg.id
}

# S3 Outputs
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.main_bucket.arn
}

# Route Table Outputs
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_rt.id
}

# Internet Gateway Output
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}
