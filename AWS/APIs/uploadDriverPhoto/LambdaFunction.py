import json
import base64
import boto3

client=boto3.client('s3')

def lambda_handler(event, context):
    
    busUID = event['queryStringParameters']['busUID']
    
    driverPhoto=base64.b64decode(event['body'])
    response = client.put_object(
    Body=driverPhoto,
    Bucket='apbtms-driver-photos',
    Key=busUID+'.jpg',
)

    print(response)
    return {
        'statusCode': 200,
        'headers': {
            'allow-access-control-origin': '*'
        },
        'body': json.dumps('Driver Photo uploaded successfully')
    }
