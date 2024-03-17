output "kinesis_stream_name" {
  value = module.stream_processing.kinesis_stream_name
}

output "sns_topic_arn" {
  value = module.stream_processing.sns_topic_arn
}

output "lambda_function_name" {
  value = module.stream_processing.lambda_function_name
}

output "server_public_dns" {
  value = module.stream_processing.server_public_dns
}