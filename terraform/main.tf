provider "aws" {
  region  = "us-east-1"
  profile = "realtime_rider_tracker_profile"
}

module "stream_processing" {
  source               = "./modules/stream_processing"
  project              = "RiderLocationTracking"
  environment          = "Development"
  created_by           = "Luis Barral"
}