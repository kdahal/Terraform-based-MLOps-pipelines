provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_s3_bucket" "mlops_bucket" {
  bucket = "my-mlops-bucket-${random_string.suffix.result}"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "MLOps Data Bucket"
  }
}

resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_sagemaker_notebook_instance" "mlops_notebook" {
  name          = "mlops-notebook-instance"
  role_arn      = aws_iam_role.sagemaker_role.arn
  instance_type = var.instance_type

  tags = {
    Name = "MLOps Notebook"
  }
}

# Include sagemaker_pipeline.tf for full pipeline
include "sagemaker_pipeline.tf"
