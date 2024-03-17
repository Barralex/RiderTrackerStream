# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "rider_location_processor_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Project     = var.project
    Environment = var.environment
    CreatedBy   = var.created_by
  }
}

# IAM Role Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "rider_location_processor_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*",
        Effect   = "Allow"
      },
      {
        Action = [
          "sns:Publish"
        ],
        Resource = aws_sns_topic.rider_location_updates_topic.arn,
        Effect   = "Allow"
      },
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListStreams"
        ],
        Resource = aws_kinesis_stream.rider_location_stream.arn,
        Effect   = "Allow"
      }
    ]
  })
}