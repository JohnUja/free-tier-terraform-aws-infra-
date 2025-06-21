# Terraform AWS Infrastructure Project
# Clean infrastructure with minimal modules and custom resources

# VPC Module - Only for basic VPC creation
module "vpc" {
  source = "github.com/JohnUja/AWS-IAC-Terraform-Module-//vpc"
  vpc_cidr = var.vpc_cidr
}

# Custom Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Custom Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Custom Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az

  tags = merge(var.tags, {
    Name        = "${var.project_name}-private-subnet"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
    Project     = var.project_name
  })
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Custom Security Groups
resource "aws_security_group" "app_sg" {
  name_prefix = "${var.project_name}-app-"
  vpc_id      = module.vpc.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-app-sg"
    Environment = var.environment
    Project     = var.project_name
  })
}

resource "aws_security_group" "db_sg" {
  name_prefix = "${var.project_name}-db-"
  vpc_id      = module.vpc.vpc_id

  # Database access from app security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "PostgreSQL access from app"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-db-sg"
    Environment = var.environment
    Project     = var.project_name
  })
}

# S3 Bucket for General Storage
resource "aws_s3_bucket" "main_bucket" {
  bucket = "${var.project_name}-storage-${var.environment}-${random_string.bucket_suffix.result}"

  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main_bucket_public_access_block" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main_bucket_encryption" {
  bucket = aws_s3_bucket.main_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Random string for unique bucket names
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
