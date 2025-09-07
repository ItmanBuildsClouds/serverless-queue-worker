import json
import boto3
import os
import uuid
from datetime import datetime, timezone

QUEUE_URL = os.environ.get('QUEUE_URL')
if not QUEUE_URL:
    raise Exception('QUEUE_URL environment variable not set')

sqs = boto3.client('sqs')

def lambda_handler(event, context):
    try:
        body = json.loads(event.get('body', "{}"))

        if not body:
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "message": "Invalid request body"
                })
            }
        body['orderId'] = str(uuid.uuid4())
        body['created_at'] = datetime.now(timezone.utc).isoformat()
        body['status'] = "PENDING"
        print(f"Sending message to queue: {QUEUE_URL}")

        sqs.send_message(
            QueueUrl=QUEUE_URL,
            MessageBody=json.dumps(body)
        )

        print("Message sent correctly to queue")
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Order received",
                "orderId": body['orderId'],
                "created_at": body['created_at'],
                "status": body['status']
            })
        }

    except Exception as e:
        print(e)
        return {
            "statusCode": 500,
            "body": json.dumps({
                "message": "Some error occurred"
            })
        }