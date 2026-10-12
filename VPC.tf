resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.environment}-subnet"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-jenkins-terraform-bucket-${var.environment}-12345"

  tags = {
    Environment = var.environment
  }
}