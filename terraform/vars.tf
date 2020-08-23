variable "AWS_REGION" {
  default = "us-east-1"
}


data archive_file lambda {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}

