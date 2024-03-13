
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
            courier = Courier(i, 'RiderLocationStream')
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
