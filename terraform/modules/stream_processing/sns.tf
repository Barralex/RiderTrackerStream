# SNS Topics

resource "aws_sns_topic" "rider_location_updates_topic" {
  name = "rider-location-updates-topic"
  tags = {
    Project     = var.project
    Environment = var.environment
    CreatedBy   = var.created_by
  }
}
