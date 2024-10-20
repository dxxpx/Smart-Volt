      
#include <WiFi.h>
#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>
#include "DHT.h"
#define DHTTYPE DHT11     
#define BLYNK_TEMPLATE_ID "TMPL3cEB67lyb"
#define BLYNK_TEMPLATE_NAME "Test"
char ssid[] = "12345678";//your wifi ssid -no special characers or complex words
char pass[] = "1234567800";//your wifi password -no special characers or complex words

#define BLYNK_AUTH_TOKEN "eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V"

char auth[] = "eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V";
#define BLYNK_TEMPLATE_ID "TMPL3cEB67lyb"
#define BLYNK_TEMPLATE_NAME "Test"

#define BLYNK_PRINT Serial
#define BLYNK_DEVICE_NAME "Dev1"  


#define DHTPIN 32         
#define pin1 13

float a=790;
float b = 0;
float c = 980;
float d = 200;
int e = 500;

float rated_current=6.5;
const int sensorIn = 34;
const int relay = 26;
const int vibration = 33;
int mVperAmp = 185;           
int Watt = 0;
double Voltage = 0;
double VRMS = 0;
double AmpsRMS = 0;
double present_condition = 0;
double previous_condition = 0;
#define SENSOR_PIN 18

DHT dht(DHTPIN, DHTTYPE);
BlynkTimer timer;
void sendSensor()
{
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int vib = digitalRead(vibration);
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  Blynk.virtualWrite(V0, h); 
  Blynk.virtualWrite(V1, t); 
  Blynk.virtualWrite(V2, VRMS);
  //Blynk.virtualWrite(V3, y);
  Blynk.virtualWrite(V3, vib);
}

void setup() {
  Serial.begin(74880);
  delay(1000);
  pinMode(vibration,INPUT);
  pinMode(34,OUTPUT);
  Blynk.begin(auth, ssid, pass);
  dht.begin();
  timer.setInterval(1000L, sendSensor);
  pinMode(relay,OUTPUT);
}
 
BLYNK_WRITE(V4) {
 virtualPinValue = param.asInt();
 if (virtualPinValue==0)
 {
      digitalWrite(relay,HIGH);//NO config opens the circuit 
    }
    else {
      digitalWrite(relay,LOW);//turn on equipment connected to mains supply
    }
//}

void loop() 
{
  //Serial.println (""); 
  Voltage = getvpp();
  VRMS = (Voltage/2.0) *0.707;   
  AmpsRMS = ((VRMS * 1000)/mVperAmp)-0.3; 
  //Serial.print(AmpsRMS);
  //Serial.print(" Amps RMS  ---  ");
  Watt = (AmpsRMS*240/1.2);
  present_condition=AmpsRMS;
  if (previous_condition==0)
  {
      if (present_condition-previous_condition>rated_current)
      {
        digitalWrite(relay,HIGH);//NO config opens the circuit to prevent short circuit
      }
      else {
      digitalWrite(relay, LOW);
      }

  }
  else {
    if (present_condition-previous_condition>=2)
    {
      digitalWrite(relay,HIGH);//NO config opens the circuit to prevent short circuit
    }
    else {
      digitalWrite(relay, LOW);
    }
  }
  previous_condition=present_condition;


  //Serial.print(Watt);
  //Serial.println(" Watts");
  Blynk.run();
  timer.run();
}
float getvpp()
{
  float result;
  int readValue; 
  int minValue = 4096;               
  int maxValue = 0;             
   uint32_t start_time = millis();
   while((millis()-start_time) < 1000) 
   {
       readValue = analogRead(sensorIn);
       if (readValue > maxValue) 
       {
           maxValue = readValue;
       }
       if (readValue < minValue) 
       {
           minValue = readValue;
       }
   }
   result = ((maxValue - minValue) * 3.3)/4096.0; 
   return result;
 }