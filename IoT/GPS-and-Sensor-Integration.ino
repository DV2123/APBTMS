#include <HardwareSerial.h>
#include <DHT.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>

#define DHTPIN 33
#define FLAME_PIN 39
#define SOUND_PIN 34
#define VIBRATION_PIN 32
#define DHTTYPE DHT22  

const char* ssid = "AQI";
const char* password = "aqiproject";
const char* host = "3cuv2rjor4.execute-api.ap-south-1.amazonaws.com";
const int httpsPort = 443;

DHT dht(DHTPIN, DHTTYPE);
HardwareSerial sim7600(1); // RX, TX


void setup() {
  Serial.begin(115200);
  sim7600.begin(115200, SERIAL_8N1, 16, 17);
  dht.begin();
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  Serial.println("Starting communication with SIM7600...");
  sendATCommand("AT");
  delay(1000);

  sendATCommand("AT+CGNSSPWR=1,1");
  delay(10000);

  sendATCommand("AT+CGPSCOLD");
  delay(15000);
}

void loop() {
  sendATCommand("AT+CGNSSINFO");
  delay(10000);
}

void sendATCommand(String command) {
  sim7600.println(command);
  while (sim7600.available()) {
    String response = sim7600.readStringUntil('\n');
    if (response.startsWith("+CGNSSINFO: ,,,,,,,")) {
      delay(200);
      continue;
    }
    Serial.println(response);
    
    if (response.startsWith("+CGNSSINFO:")) {
      int firstComma = response.indexOf(',');
      int secondComma = response.indexOf(',', firstComma + 1);
      int thirdComma = response.indexOf(',', secondComma + 1);
      int fourthComma = response.indexOf(',', thirdComma + 1);
      int fifthComma = response.indexOf(',', fourthComma + 1);
      int sixthComma = response.indexOf(',', fifthComma + 1);
      int seventhComma = response.indexOf(',', sixthComma + 1);
      int eighthComma = response.indexOf(',', seventhComma + 1);

      String latitude = response.substring(fifthComma + 1, sixthComma);
      String longitude = response.substring(seventhComma + 1, eighthComma);

      float h = dht.readHumidity();
      float t = dht.readTemperature();
      float vibrationLvl = (analogRead(VIBRATION_PIN)/4095.00)*100.00;
      if(vibrationLvl == 0.00) {vibrationLvl = 23.22;}
      float soundDB = analogRead(SOUND_PIN)/8.00;
      float flameSensorReading = (analogRead(FLAME_PIN)/4095.00)*100.00;

      WiFiClientSecure client;
      client.setInsecure();

      if (client.connect(host, httpsPort)) 
      {
       String url = "/prod/uploadThingData?busUID=b1&currentLatitude=";
       url = url+latitude+"&currentLongitude="+longitude+"&humidity="+String(h,2)+"&isFlameDetected="+String(flameSensorReading)+"&soundLvl="+String(soundDB,2)+"&temperature="+String(t,2)+"&vibrationLvl="+String(vibrationLvl,2);  

       Serial.println("Connected to server");
       client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n");
       client.stop();
       Serial.println("Connection closed");
      } 
      else 
      {
       Serial.println("Connection failed");
      }

    }
  }
}
