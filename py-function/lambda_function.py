import json
import os

def lambda_handler(event, context):
    # secret = get_secret()
    secret = os.environ.get('SECRET_VALUE', 'Not Set')
    return {
        'statusCode': 200,
        'body': json.dumps(f'Hello from Python Lambda Function deployed with TF ! This is a secret: {secret}')
    }
