//This is the logger joining the program which logs Co2 sensor data and the program which logs humidity data. JointLogger1 fixes negative number problem and adds blinking LED. 01/03/2015

//Libraries
#include <SoftwareSerial.h> //Serial to digital pins
#include "DHT.h" //Humidity

//Definitions
#define PrintBufLen 100
#define DHTPIN 2 
#define DHTTYPE DHT22 //DHT 22 (AM2302)

//Variables
char GetReadingCmd[]={0xff, 0x01, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79};// buffer of 9 characters
unsigned char Co2Data[]={0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};// buffer of 10 characters
char PrintBuf[PrintBufLen];

//TODO: setup a buffer to receive at least 9 characters from the Co2 sensor.
SoftwareSerial usbSerial(10, 11); //Pin 10 is RX_IN, Pin 11 is Tx_OUT
SoftwareSerial co2Serial(8, 9); //Pin 8 is RX_IN, Pin 9 is Tx_OUT

//TODO: initialize DHT sensor for normal 16mhz Arduino.
DHT dht(DHTPIN, DHTTYPE);

unsigned long int k=0;//0xFFFFFFF0;

void ClearPrintBuf(){
  for(int i=0; i<PrintBufLen; i++){
    PrintBuf[i]=0x00;
  }
}

void setup(){
  
  pinMode(13, OUTPUT);
  
  usbSerial.begin(9600);
  co2Serial.begin(9600);
  dht.begin();
 
  //TODO: send the GetReadingCmd buffer to the Co2 sensor.
  for(int i=0; i<9; i++){
    co2Serial.write(GetReadingCmd[i]);
  }
}

void loop(){ 
  
  //TODO: Wait till you receive 9 characters.
  if(co2Serial.available() >= 9){
    for(int i=0; i<9; i++){
      Co2Data[i]=co2Serial.read();    
    }

    unsigned int Co2Val=((unsigned int)Co2Data[2])*256+((unsigned int)Co2Data[3]);
    
    // Reading temperature or humidity takes about 250 milliseconds!
    // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
    float h = dht.readHumidity();
    // Read temperature as Celsius
    float t = dht.readTemperature();
    // Read temperature as Fahrenheit
    //float f = dht.readTemperature(true);
    
    unsigned int h_int=(unsigned int)h;
    unsigned int h_frac=(h-(float)h_int)*100;
    
    unsigned int t_int=(unsigned int)t;
    unsigned int t_frac=(t-(float)t_int)*100;
    
    ClearPrintBuf();
    //sprintf(PrintBuf,"The Carbon Dioxide Concentration is: ",Co2Val,"%d\n\r","The Humidity is: ",h,"%d\n\r");
    
    sprintf(PrintBuf,"%lu,%d.%d,%d.%d,%d\r",k,t_int,t_frac,h_int,h_frac,Co2Val);
    
    usbSerial.write(PrintBuf);
    
    //TODO: wait here for 1 second(s) before looping back.
    //delay(821);// too fast
    //delay(900);// slow
    //delay(837); // actual value is between 837 and 838
    delay(1690);
    
    //TODO: send the GetReadingCmd buffer to the Co2 sensor.
    for(int i=0; i<9; i++){
      co2Serial.write(GetReadingCmd[i]);
    }
    
    digitalWrite(13,k&0x00000001);
    k++;
  }//endif(co2Serial.available() == 9)
  else{// until there are 9 bytes in the buffer, there is nothing else we can do.
  }
}


// k&0x00000001
