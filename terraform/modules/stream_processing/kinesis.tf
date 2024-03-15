# Kinesis Stream
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
    Project     = var.project
    Environment = var.environment
    CreatedBy   = var.created_by
  }
}
