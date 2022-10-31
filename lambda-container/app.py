import json
import subprocess
import os

def lambda_handler(event, context):    
    
    secret1 = os.environ.get('SECRET_VALUE_1', 'Not Set')
    secret2 = os.environ.get('SECRET_VALUE_2', 'Not Set')
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Hello from Python Lambda Function deployed with TF ! This is a secret1: {secret1}! This is a secret2: {secret2}! "Lambda Event: {event}')
    }