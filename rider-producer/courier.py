import time
import random
from kinesis import KinesisHandler
from botocore.exceptions import BotoCoreError, ClientError


class Courier:
    def __init__(self, device_id, stream_name):
        self.device_id = device_id
        # Define Pocitos' latitude and longitude boundaries
        lat_min, lat_max = -34.920, -34.9085
        long_min, long_max = -56.155, -56.1398
        # Generate a random starting location within the boundaries
        start_lat = random.uniform(lat_min, lat_max)
        start_long = random.uniform(long_min, long_max)
        self.location = (start_lat, start_long)
        self.running = True
        # Adjust the movement vector for bicycle speed (4.17 m/s)
        self.movement_vector = (4.17 / 111000, 0)
        self.kinesis_handler = KinesisHandler(stream_name)

    def update_location(self):
        new_location = (self.location[0] + self.movement_vector[0],
                        self.location[1] + self.movement_vector[1])
        self.location = new_location

    def stop(self):
        self.running = False

    def run(self):
        try:
            while self.running:
                self.update_location()

                data = {
                    "device_id": self.device_id,
                    "lat": self.location[0],
                    "long": self.location[1],
                    "timestamp": int(time.time())
                }

                try:
                    self.kinesis_handler.send_message(data, "0")
                except ClientError as e:
                    print(f"ClientError in thread {self.device_id}: {e}")
                except BotoCoreError as e:
                    print(f"BotoCoreError in thread {self.device_id}: {e}")

                url = f"https://www.google.com/maps/search/?api=1&query={self.location[0]},{self.location[1]}"
                print(f"{self.device_id} = {self.location[0]}, {self.location[1]} -> {url}")

                time.sleep(1)
        except Exception as e:
            print(f"Error in thread {self.device_id}: {e}")
