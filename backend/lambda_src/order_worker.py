import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE')
if not TABLE_NAME:
    raise Exception('TABLE_NAME environment variable not set')
table = dynamodb.Table(TABLE_NAME)



def lambda_handler(event, context):
    for record in event.get('Records', []):
        try:
            body_str = record.get('body')
            if not body_str:
                print("No body in record")
                continue
            body = json.loads(body_str)
            orderId = body.get('orderId')
            if not orderId:
                print("No orderId in body")
                continue

            print(f"Try put {orderId} on DynamoDB")

            table.put_item(
                Item=body
            )
            print(f"Order {orderId} saved on DynamoDB")

        except Exception as e:
            print(e)
            print(f"Error processing record: {record}")
            raise e

    return {
            "statusCode": 200,
            "body": json.dumps({"message": "Order received"})
            }


