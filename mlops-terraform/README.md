# Terraform-Based MLOps Pipelines

Automate ML infrastructure with Terraform on AWS. This extends basic setups to include SageMaker Pipelines for end-to-end MLOps (data prep, training, deployment).

## Setup
- AWS CLI configured.
- Terraform >=1.0.
- Run: `terraform init && terraform plan && terraform apply`

## Resources
- S3 bucket for artifacts.
- IAM roles.
- SageMaker Notebook + Pipeline for automated training.