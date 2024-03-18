import json
import base64
import boto3
import os

# Initialize the SNS client
sns_client = boto3.client('sns')


def lambda_handler(event, context):
    records = []

    # Processing each record in the event
    for record in event['Records']:
        # Decoding the record from base64 encoding
        payload = base64.b64decode(record["kinesis"]["data"])
        data = json.loads(payload)
        records.append(data)

    # Aggregating messages
    aggregated_message = [
        {'device_id': record['device_id'], 'lat': record['lat'], 'long': record['long']}
        for record in records
    ]

    # Sorting the aggregated messages
    aggregated_message_sorted = sorted(aggregated_message, key=lambda x: int(x['device_id']))

    # Logging the sorted data
    print("Aggregated and Sorted Data:", aggregated_message_sorted)

    # Publishing the sorted data to the SNS topic
    sns_response = sns_client.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message=json.dumps({'default': json.dumps(aggregated_message_sorted)}),
        MessageStructure='json'
    )

    # Return the response and the status
    return {"status": "Success", "data": aggregated_message_sorted, "snsResponse": sns_response}
