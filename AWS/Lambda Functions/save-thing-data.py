import json
import boto3
from decimal import Decimal
from datetime import datetime
import http.client

dynamodb = boto3.resource('dynamodb')
busesTable = dynamodb.Table('Buses')
thingRecordTable = dynamodb.Table('thing-data-records')
mNotifsTable = dynamodb.Table('Management-Notifications')


def lambda_handler(event, context):
    
    now = datetime.utcnow()
    currentDateTime = now.strftime("%d/%m/%Y %H:%M:%S")
    
    busUID = event['queryStringParameters']['busUID']

    currentLatitude = event['queryStringParameters']['currentLatitude']
    currentLongitude = event['queryStringParameters']['currentLongitude']
    humidity = event['queryStringParameters']['humidity']
    isFlameDetected = event['queryStringParameters']['isFlameDetected']
    soundLvl = event['queryStringParameters']['soundLvl']
    temperature = event['queryStringParameters']['temperature']
    vibrationLvl = event['queryStringParameters']['vibrationLvl']
    
    
    
    api_url = "ap-south-1.aws.neurelo.com"
    path = "/custom/save-thing-data"
    payload = {
            "busUID": busUID,
            "currentLatitude": float(currentLatitude),
            "currentLongitude": float(currentLongitude),
            "humidity": int(float(humidity)),
            "isFlameDetected": int(float(isFlameDetected)),
            "soundLvl": int(float(soundLvl)),
            "temperature": int(float(temperature)),
            "vibrationLvl": int(float(vibrationLvl))
        }
    json_payload = json.dumps(payload)
    headers = {"Content-Type": "application/json", "X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="}
    
    
    try:
        conn = http.client.HTTPSConnection(api_url)
        conn.request("POST", path, json_payload, headers)
        response = conn.getresponse()
        response_data = response.read().decode("utf-8")
        
    except Exception as e:
        print(e)
        return {"statusCode": 500, "body": str(e)}
    
    
    if int(float(temperature)) > 80 and int(float(isFlameDetected)) < 20:
        mNotifsTable.put_item(
            Item={
             'DateTime': currentDateTime+" "+busUID+" fire",
             'DTstamp': currentDateTime,
             'busUID': busUID,
             'Message': "Chances of fire in this bus are High"
            })
        
        path = "/rest/ManagementNotifications/__one"
        payload = {
                'DateTime': currentDateTime+" "+busUID+" fire",
                'DTstamp': currentDateTime,
                'busUID': busUID,
                'Message': "Chances of fire in this bus are High"
                }
        json_payload = json.dumps(payload)
        headers = {"Content-Type": "application/json", "X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="}
    
    
        try:
            conn = http.client.HTTPSConnection(api_url)
            conn.request("POST", path, json_payload, headers)
            response = conn.getresponse()
            response_data = response.read().decode("utf-8")
        
        except Exception as e:
            print(e)
            return {"statusCode": 500, "body": str(e)}
            

      
# Vonage SMS API integrated with our micro service.
      
        api_url = "rest.nexmo.com"    
        path = "/sms/json"
        payload = {
                "from": "Vonage APIs",
                "text": "Chances of fire in this bus "+str(busUID)+" are High",
                "to": "918128493035",
                "api_key": "ae08f75e",
                "api_secret": "VdcCe5kb4I6GoBgN"
                }
        json_payload = json.dumps(payload)
        headers = {"Content-Type": "application/json"}
    
        try:
            conn = http.client.HTTPSConnection(api_url)
            conn.request("POST", path, json_payload, headers)
            response = conn.getresponse()
            response_data = response.read().decode("utf-8")

        except Exception as e:
            print(e)
            return {"statusCode": 500, "body": str(e)}

  
        
    
    if int(float(soundLvl)) >= 80:
        mNotifsTable.put_item(
            Item={
             'DateTime': currentDateTime+" "+busUID+" sound",
             'DTstamp': currentDateTime,
             'busUID': busUID,
             'Message': "Abnormally loud sound level detected, Chances of crash in this bus are High"
            })
            
        api_url = "ap-south-1.aws.neurelo.com" 
        path = "/rest/ManagementNotifications/__one"
        payload = {
             'DateTime': currentDateTime+" "+busUID+" sound",
             'DTstamp': currentDateTime,
             'busUID': busUID,
             'Message': "Abnormally loud sound level detected, Chances of crash in this bus are High"
                }
        json_payload = json.dumps(payload)
        headers = {"Content-Type": "application/json", "X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="}
    
    
        try:
            conn = http.client.HTTPSConnection(api_url)
            conn.request("POST", path, json_payload, headers)
            response = conn.getresponse()
            response_data = response.read().decode("utf-8")
        
        except Exception as e:
            print(e)
            return {"statusCode": 500, "body": str(e)}
            
    
    if int(float(vibrationLvl)) > 80:
        mNotifsTable.put_item(
            Item={
             'DateTime': currentDateTime+" "+busUID+" vibration",
             'DTstamp': currentDateTime,
             'busUID': busUID,
             'Message': "Chances of being on uneven ground, bad vehicle state, accident are high"
            })
            
        api_url = "ap-south-1.aws.neurelo.com" 
        path = "/rest/ManagementNotifications/__one"
        payload = {
             'DateTime': currentDateTime+" "+busUID+" vibration",
             'DTstamp': currentDateTime,
             'busUID': busUID,
             'Message': "Chances of being on uneven ground, bad vehicle state, accident are high"
            }
        json_payload = json.dumps(payload)
        headers = {"Content-Type": "application/json", "X-API-KEY": "neurelo_9wKFBp874Z5xFw6ZCfvhXSWjn5HaGax0iEIv7FlN0VhmOVVtFbJEXJBsgFnFGucZ++OTzYmBZ2xlTwkG3Xbt80xHUKdR788dvKiF8ipMZKSmIXyEJU7NAgrMIZ7wbDmQhq8RNfLKr5CuLxMTzqxgqsFHBDd70swCInlghCPJj8GgZubiiqnMNhcw1AXkJACn_bF9SeH4Sv8OeECAqt8ONQKXFxJvnErwoo6bL+2rAnXk="}
    
    
        try:
            conn = http.client.HTTPSConnection(api_url)
            conn.request("POST", path, json_payload, headers)
            response = conn.getresponse()
            response_data = response.read().decode("utf-8")
        
        except Exception as e:
            print(e)
            return {"statusCode": 500, "body": str(e)}
            

    response = busesTable.update_item(
        Key={'busUID': busUID},
        UpdateExpression="set currentLatitude=:a, currentLongitude=:b, humidity=:c, isFlameDetected=:d, soundLvl=:e, temperature=:f, vibrationLvl=:g",
        ExpressionAttributeValues={
            ':a': Decimal(currentLatitude),
            ':b': Decimal(currentLongitude),
            ':c': Decimal(humidity),
            ':d': Decimal(isFlameDetected),
            ':e': Decimal(soundLvl),
            ':f': Decimal(temperature),
            ':g': Decimal(vibrationLvl),
        },
        ReturnValues="UPDATED_NEW")
        
        
    response2 = thingRecordTable.put_item(
                Item={
                    'DateTime': currentDateTime+" "+busUID,
                    'busUID': busUID,
                    'currentLatitude': Decimal(currentLatitude),
                    'currentLongitude': Decimal(currentLongitude),
                    'humidity': Decimal(humidity),
                    'isFlameDetected': Decimal(isFlameDetected),
                    'soundLvl': Decimal(soundLvl),
                    'temperature': Decimal(temperature),
                    'vibrationLvl': Decimal(vibrationLvl), 
                })

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            "access-control-allow-origin": "*"
        },
        'body': json.dumps('SUCCESS')
    }
