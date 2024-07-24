#include "esp_camera.h"
#include "base64.h"
#include <WiFi.h>
#include <HTTPClient.h>



#define CAMERA_MODEL_AI_THINKER

// Replace with your network credentials
const char* ssid = "AQI";
const char* password = "aqiproject";
const char* serverURL = "https://3cuv2rjor4.execute-api.ap-south-1.amazonaws.com/prod/uploadBusInsideImage?busUID=b1";

// Camera settings

#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22



void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(false);

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("");
  Serial.println("WiFi connected");

  // Initialize camera
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sscb_sda = SIOD_GPIO_NUM;
  config.pin_sscb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG;
  config.frame_size = FRAMESIZE_SVGA;
  config.jpeg_quality = 10;
  config.fb_count = 2;

  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }
}

void loop() {
  captureAndEncodeToBase64();
   // Capture an image every 10 seconds

  delay(30000);
}

void captureAndEncodeToBase64() {
  camera_fb_t * fb = NULL;
  // Capture an image
  fb = esp_camera_fb_get();
  if (!fb) {
    Serial.println("Camera capture failed");
    return;
  }

  // Convert the image to base64
  String base64Image = base64::encode(fb->buf, fb->len);

  // Release the image buffer
  esp_camera_fb_return(fb);

  // Start the HTTPClient
  HTTPClient http;

  // Set the target server and the headers
  http.begin(serverURL);
  http.addHeader("Content-Type", "application/json");

  // Perform the POST request
  int httpResponseCode = http.POST(base64Image);

  // Check for a successful response
  if (httpResponseCode > 0) {
    Serial.printf("HTTP Response code: %d\n", httpResponseCode);
    String response = http.getString();
    Serial.println(response);
  } else {
    Serial.printf("Error during HTTP request: %s\n", http.errorToString(httpResponseCode).c_str());
  }

  // Close the connection
  http.end();

}