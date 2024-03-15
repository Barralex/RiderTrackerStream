# Kinesis Stream
resource "aws_kinesis_stream" "rider_location_stream" {
  name             = "rider-location-stream"
  shard_count      = 1
  retention_period = 24
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "IncomingRecords"
  ]

  tags = {
    Project     = var.project
    Environment = var.environment
    CreatedBy   = var.created_by
  }
}

