variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "Notebook instance type"
  type        = string
  default     = "ml.t2.medium"
}
