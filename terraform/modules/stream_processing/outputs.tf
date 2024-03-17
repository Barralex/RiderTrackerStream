output "kinesis_stream_name" {
  value = aws_kinesis_stream.rider_location_stream.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.rider_location_updates_topic.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.rider_location_processor.function_name
}

output "server_public_dns" {
  value = "http://${aws_eip.ip.public_dns}"
}
