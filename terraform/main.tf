provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }
}


resource "aws_kinesis_stream" "rider_location_stream" {
  name             = "rider-location-stream"
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "IncomingRecords"
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Project     = "RiderLocationTracking"
    Environment = "Development",
    CreatedBy = "Luis Barral"
  }
}
