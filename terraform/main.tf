provider "aws" {
  region = "us-east-1"
}

module "stream_processing" {
  source               = "./modules/stream_processing"
  project              = "RiderLocationTracking"
  environment          = "Development"
  created_by           = "Luis Barral"
  lambda_source_file   = "${path.module}/modules/stream_processing/lambdas/aggregator_lambda.py"
  lambda_function_name = "RiderLocationProcessor"
  lambda_handler       = "aggregator_lambda.lambda_handler"
  lambda_runtime       = "python3.8"
}
