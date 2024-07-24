import json
import base64
import boto3
from io import BytesIO
import datetime

client=boto3.client('s3')


def decode(encoded_string):
  decoded_bytes = base64.b64decode(encoded_string)
  decoded_string = decoded_bytes.decode('ascii')
  return decoded_string


def lambda_handler(event, context):
    
    busUID = event['queryStringParameters']['busUID']
    
    # encodedImageString = decode(event['body'])
    encodedImageString = event['body']

    
    binaryData = base64.b64decode(encodedImageString)
    
    current_datetime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
   
    response = client.put_object(
    Body=binaryData,
    Bucket='apbtms-bus-inside-images',
    Key=busUID+'.jpg',
    ContentType='image/jpeg',
    )

    saveToCollection = client.put_object(
    Body=binaryData,
    Bucket='apbtms-bus-inside-image-collection',
    Key=current_datetime+" "+busUID,
    ContentType='image/jpeg',
    )

    print(response)
    return {
        'statusCode': 200,
        'headers': {
            'allow-access-control-origin': '*'
        },
        'body': json.dumps('SUCCESS')
    }
