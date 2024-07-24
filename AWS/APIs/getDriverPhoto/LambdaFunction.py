import boto3
import base64


def lambda_handler(event, context):
    
    image_name = event['queryStringParameters']['busUID']+'.jpg'

    bucket_name = 'apbtms-driver-photos'
    
    s3_client = boto3.client('s3')
    
    try:
        
        response = s3_client.get_object(Bucket=bucket_name, Key=image_name)
        
        file_content = base64.b64encode(response['Body'].read())
        
        return {
            'statusCode': 200,
            'headers': {
                'allow-access-control-origin': '*'
            },
            'body': file_content,
            'isBase64Encoded': True,
        }
    except Exception as e:
        # Return an error response if something goes wrong
        return {
            'statusCode': 500,
            'body': str(e)
        }
