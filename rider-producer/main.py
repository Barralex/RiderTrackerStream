"""
 ℹ️ This script acts as a fake producer that simulates couriers moving every second. It allows the user to specify the
 number of courier instances to run. Each courier operates within a specific neighborhood in Montevideo, Uruguay,
 and sends their location data to an AWS Kinesis stream for future processing.
 The purpose of this script is to demonstrate how to handle large volumes of data seamlessly.
"""

import argparse
from courier import Courier
from threading import Thread

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-riders', type=int, help='Number of riders to simulate', required=True)
    args = parser.parse_args()

    couriers = []
    threads = []
    try:
        for i in range(args.riders):
            courier = Courier(i, 'rider-location-stream')
            couriers.append(courier)
            thread = Thread(target=courier.run)
            threads.append(thread)
            thread.start()

        for thread in threads:
            thread.join()
    except KeyboardInterrupt:
        print("\nStopping all couriers...")
        for courier in couriers:
            courier.stop()
        for thread in threads:
            thread.join()
        print("All couriers have been stopped.")
