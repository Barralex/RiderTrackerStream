import json
import base64


def lambda_handler(event, context):
    records = []

    # Processing records
    for record in event['Records']:
        # Decoding from base64
        payload = base64.b64decode(record["kinesis"]["data"])
        data = json.loads(payload)
        records.append(data)

    # Message aggregation
    aggregated_message = [
        {'device_id': record['device_id'], 'lat': record['lat'], 'long': record['long']}
        for record in records
    ]

    # Sorting aggregated messages by device_id from smallest to largest
    aggregated_message_sorted = sorted(aggregated_message, key=lambda x: int(x['device_id']))

    # Print the aggregated and sorted data
    print("Aggregated and Sorted Data:", aggregated_message_sorted)

    # The aggregated and sorted message will be automatically sent to SNS
    return {"status": "Success", "data": aggregated_message_sorted}
