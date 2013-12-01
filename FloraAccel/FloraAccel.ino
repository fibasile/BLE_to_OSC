#include <Wire.h>
#include <Adafruit_LSM303.h>
#include <HardwareSerial.h>
#include "FixedFirmata.h"


Adafruit_LSM303 lsm;

static byte REPORT_ACCEL=0x07;

void setup() 
{
  Serial.begin(9600);

  // Try to initialise and warn if we couldn't detect the chip
  if (!lsm.begin())
  {
    Serial.println("Oops ... unable to initialize the LSM303. Check your wiring!");
    while (1);
  }
  Firmata.setFirmwareVersion(0,1);
//  Firmata.attach(START_SYSEX, sysexCallback);
  Firmata.begin(57600);
}

void readAcceleration() {
    lsm.read();
//    Serial.print("Accel X: "); Serial.print((int)lsm.accelData.x); Serial.print(" ");
//    Serial.print("Y: "); Serial.print((int)lsm.accelData.y);       Serial.print(" ");
//    Serial.print("Z: "); Serial.println((int)lsm.accelData.z);     Serial.print(" ");
//    Serial.print("Mag X: "); Serial.print((int)lsm.magData.x);     Serial.print(" ");
//    Serial.print("Y: "); Serial.print((int)lsm.magData.y);         Serial.print(" ");
//    Serial.print("Z: "); Serial.println((int)lsm.magData.z);       Serial.print(" ");
}

void reportAcceleration(){
    int accel_x = (int) lsm.accelData.x;
    int accel_y = (int) lsm.accelData.y;
    int accel_z = (int) lsm.accelData.z;
    byte pack[6] = { lowByte(accel_x), highByte(accel_x), lowByte(accel_y), highByte(accel_y), lowByte(accel_z), highByte(accel_z)}; 

    Firmata.sendSysex(REPORT_ACCEL, 6, (byte*)pack);
}




void loop() 
{
	readAcceleration();
	reportAcceleration();
	delay(200);
}
