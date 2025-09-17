output "notebook_url" {
  value = aws_sagemaker_notebook_instance.mlops_notebook.url
}

output "s3_bucket_name" {
  value = aws_s3_bucket.mlops_bucket.bucket
}