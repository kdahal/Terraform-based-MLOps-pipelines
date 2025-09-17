# SageMaker Pipeline for automated MLOps (e.g., training job)
resource "aws_sagemaker_model" "ml_model" {
  name        = "mlops-model"
  execution_role_arn = aws_iam_role.sagemaker_role.arn

  primary_container {
    image = "246618370639.dkr.ecr.us-west-2.amazonaws.com/sagemaker-tensorflow:2.3.1-cpu-py37-ubuntu18.04"
    model_data_url = "s3://${aws_s3_bucket.mlops_bucket.bucket}/models/model.tar.gz"
  }
}

# Example Training Job (trigger via pipeline)
resource "aws_sagemaker_training_job" "ml_training" {
  name     = "mlops-training-job"
  role_arn = aws_iam_role.sagemaker_role.arn

  algorithm_specification {
    training_image = "246618370639.dkr.ecr.us-west-2.amazonaws.com/sagemaker-tensorflow:2.3.1-cpu-py37-ubuntu18.04"
    training_input_mode = "File"
  }

  input_data_config {
    channel_name = "training"
    data_source = "s3://${aws_s3_bucket.mlops_bucket.bucket}/data/training/"
  }

  output_data_config {
    s3_output_path = "s3://${aws_s3_bucket.mlops_bucket.bucket}/output/"
  }

  resource_config {
    instance_count = 1
    instance_type  = "ml.m5.large"
    volume_size_in_gb = 10
  }

  stopping_condition {
    max_wait_time_in_seconds = 3600
  }

  tags = {
    Name = "MLOps Training"
  }
}

# For full pipelines, use aws_sagemaker_pipeline resource (define JSON spec in a file)
