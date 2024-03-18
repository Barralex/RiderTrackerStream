# rider_location_processor Lambda Function
resource "aws_lambda_function" "rider_location_processor" {
  function_name    = "RiderLocationProcessor"
  handler          = "aggregator_lambda.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_exec_role.arn
  filename         = data.archive_file.aggregator_lambda.output_path
  source_code_hash = filebase64sha256(data.archive_file.aggregator_lambda.output_path)
  timeout          = 5

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# Event Source Mapping for Lambda - Configures the Lambda function to be triggered by the Kinesis stream.
resource "aws_lambda_event_source_mapping" "kinesis_event_source_mapping" {
  event_source_arn  = aws_kinesis_stream.rider_location_stream.arn
  function_name     = aws_lambda_function.rider_location_processor.arn
  starting_position = "LATEST" # LATEST ensures that only new records are processed.
}

# Lambda Event Invoke Config - Defines the SNS topic as the destination for successful Lambda invocations.
resource "aws_lambda_function_event_invoke_config" "lambda_invoke_config" {
  function_name = aws_lambda_function.rider_location_processor.function_name
  qualifier     = "$LATEST"

  destination_config {
    on_success {
      destination = aws_sns_topic.rider_location_updates_topic.arn
    }
  }
}


data "archive_file" "aggregator_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambdas/aggregator_lambda.py"
  output_path = "${path.module}/lambdas/outputs/aggregator_lambda.zip"
}
