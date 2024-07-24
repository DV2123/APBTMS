import json
import boto3
from datetime import datetime
import http.client


rekognition = boto3.client('rekognition', 'ap-south-1')

dynamoDB = boto3.resource('dynamodb')

busesTable = dynamoDB.Table("Buses")
passengerCountRecordTable = dynamoDB.Table("Passenger_Count_Record")
blacklistTable = dynamoDB.Table("blacklist")
managementNotifTable = dynamoDB.Table("Management-Notifications")


def lambda_handler(event, context):
    now = datetime.utcnow()
    currentDateTime = now.strftime("%d/%m/%Y %H:%M:%S")
    cntr=1
    totalPassengers = 0
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    rekognitionResponse = rekognition.detect_labels(
        Image={
            "S3Object": {
                "Bucket": bucket,
                "Name": key,
            }
        },
    )

    for label in rekognitionResponse['Labels']:
        if label['Name'] == 'Person':
            totalPassengers += len(label['Instances'])
            break
          
    
    api_url = "ap-south-1.aws.neurelo.com"
    path = "/custom/update-current-passengers"
    payload = {"busUID": key.replace('.jpg', ''), "currentNumberOfPassenger": totalPassengers}
    json_payload = json.dumps(payload)
    headers = {"Content-Type": "application/json", "X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="}
    
    
    try:
        conn = http.client.HTTPSConnection(api_url)
        conn.request("POST", path, json_payload, headers)
        response = conn.getresponse()
        response_data = response.read().decode("utf-8")
        if response.status < 300:
            return {"statusCode": response.status, "body": response_data}
        else:
            return {"statusCode": response.status, "body": "Request failed"}
        
    except Exception as e:
        print(e)
        return {"statusCode": 500, "body": str(e)}


    busesTable.update_item(
        Key={
            'busUID': key.replace('.jpg', ''),
        },
        UpdateExpression="set currentNumberOfPassenger = :r",
        ExpressionAttributeValues={
            ':r': totalPassengers,
        },
        ReturnValues="UPDATED_NEW"
    )
    
    passengerCountRecordTable.put_item(
        Item={
            'DateTime': currentDateTime+" "+key.replace(".jpg", ""),
            'busUID': key.replace(".jpg", ""),
            'PassengerCount': totalPassengers,
        }
    )


    return {
        'statusCode': 200,
        'body': json.dumps('SUCCESS')
    }
