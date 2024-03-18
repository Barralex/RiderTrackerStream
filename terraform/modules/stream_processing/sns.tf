# SNS Topics

resource "aws_sns_topic" "rider_location_updates_topic" {
  name = "rider-location-updates-topic"
  tags = {
    Project     = var.project
    Environment = var.environment
    CreatedBy   = var.created_by
  }
}

resource "time_sleep" "wait_120_seconds" {
  create_duration = "120s"
}

resource "aws_sns_topic_subscription" "rider_location_updates_subscription" {
  topic_arn = aws_sns_topic.rider_location_updates_topic.arn
  protocol  = "http"
  endpoint  = "http://${aws_eip.ip.public_dns}/updates"

  depends_on = [time_sleep.wait_120_seconds]
}


