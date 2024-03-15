import boto3
import json


class KinesisHandler:
    def __init__(self, stream_name):
        self.stream_name = stream_name
        self.client = boto3.Session(profile_name='realtime_rider_tracker_profile').client('kinesis', region_name='us-east-1')

    def send_message(self, data, partition_key):
        try:
            self.client.put_record(
                StreamName=self.stream_name,
                Data=json.dumps(data),
                PartitionKey=partition_key
            )
        except Exception as e:
            print(f"Error sending data to Kinesis: {e}")