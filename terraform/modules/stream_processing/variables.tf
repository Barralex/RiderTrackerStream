variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "created_by" {
  type        = string
  description = "Creator of the resource"
}

variable "lambda_source_file" {
  type        = string
  description = "Source file for the Lambda function"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "lambda_handler" {
  type        = string
  description = "Handler for the Lambda function"
}

variable "lambda_runtime" {
  type        = string
  description = "Runtime for the Lambda function"
}
