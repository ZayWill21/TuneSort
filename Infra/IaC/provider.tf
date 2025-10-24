terraform {
    required_version = "~> 1.8.5"
    backend "s3" {
     bucket = "tf_backend_${var.env}"
     key = "value"
     region = var.region
    }
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}
