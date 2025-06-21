# Terraform AWS Infrastructure Deployment Guide

## Quick Start

### Prerequisites
- Terraform >= 1.0.0 installed
- AWS CLI configured with appropriate credentials
- AWS profile with necessary permissions

### Step 1: Initialize Terraform
```bash
terraform init
```

### Step 2: Review the Plan
```bash
terraform plan
```

### Step 3: Deploy Infrastructure
```bash
terraform apply
```

### Step 4: Verify Deployment
```bash
terraform output
```

## What Gets Deployed

### ✅ VPC Module
- VPC with public and private subnets
- Internet Gateway and NAT Gateway
- Route tables and networking

### ✅ Security Module
- Security groups for different components
- IAM roles and policies
- AWS WAF rules

### ✅ EC2 Module
- EC2 instances in private subnets
- Auto-scaling groups
- Load balancers

### ✅ RDS Module
- PostgreSQL RDS instance
- Database security groups
- Backup and maintenance windows

### ✅ S3 Module
- S3 buckets for static content
- CloudFront distribution
- Bucket policies

### ✅ Cognito Module
- User pools for authentication
- User pool clients
- Identity providers

## Configuration

### Environment Variables
Create a `terraform.tfvars` file:
```hcl
aws_region = "us-east-1"
project_name = "my-project"
environment = "dev"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.0.0/24"
az = "us-east-1a"
aws_profile = "default"
```

### Available Variables
- `aws_region` - AWS region (default: us-east-1)
- `project_name` - Project name (default: terraform-project)
- `environment` - Environment (dev/staging/prod)
- `vpc_cidr` - VPC CIDR block (default: 10.0.0.0/16)
- `public_subnet_cidr` - Public subnet CIDR (default: 10.0.1.0/24)
- `private_subnet_cidr` - Private subnet CIDR (default: 10.0.0.0/24)
- `az` - Availability zone (default: us-east-1a)
- `aws_profile` - AWS profile (default: default)

## Outputs

After deployment, you'll get:
- VPC ID and CIDR block
- Subnet IDs (public and private)
- Security group IDs
- EC2 instance IDs and public IPs
- RDS endpoint and port
- S3 bucket names and ARNs
- Cognito user pool ID and client ID
- Load balancer DNS name
- CloudFront distribution domain

## Next Steps

1. **Choose Application Type** - Select from the 5 options in project_analysis.md
2. **Deploy Application** - Build and deploy your application
3. **Configure Monitoring** - Set up CloudWatch and logging
4. **Set up CI/CD** - Create deployment pipeline

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Troubleshooting

### Common Issues
1. **Module not found** - Ensure GitHub repository is accessible
2. **Permission denied** - Check AWS credentials and permissions
3. **Resource conflicts** - Ensure unique project names across environments

### Support
- Check the [AWS-IAC-Terraform-Module repository](https://github.com/JohnUja/AWS-IAC-Terraform-Module-.git)
- Review Terraform documentation
- Check AWS service limits and quotas 