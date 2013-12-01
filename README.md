BLE_to_OSC
----------

This is a sample MAC app to report accelerometer acquired from Adafruit Flora, sent using  BLE to the Mac and then converted in OSC format, for example to be forwarded to Osculator or similar apps.

Required hardware
-----------------

The demo app was tested with the following:

- Adafruit Flora
- Adafruit LSM303 Accelerometer 
- RedBear Lab BLE Mini

Connect the LSM303 accelerometer to Flora SDL and SCL, 3.3v and GND pins.

Connect the BLE mini TX to Flora RX and RX to Flora TX, 3.3v and GND pins. 	

Add a Lipo battery or plug in the USB cable to the Flora.

Required software
-----------------

Make sure you checkout the repository using the recursive option, so you also get the submodules containing all the required dependencies into the deps folder.


Instructions
------------

Make sure you have installed the Adafruit_LSM303 library in your Arduino Library folder.

Open the Adafruit Arduino IDE version, and load the FloraAccel.ino sketch you find in the folder.

This sketch uses the Firmata protocol, sending SYSEX messages containing the readings from the accelerometer. The only thing which is custom is that since accelerometer produces signed integers, those are sent as two bytes instead of one per axis.

Now compile the Mac project BleToOSC using XCode and run it.

You can configure:

- In the BLE Sensor tab: the kind of bluetooth low energy modem, currently only Ble Mini is supported, but a Xadow version will be added soon. 
- In the OSC Server tab: the OSC server host and port number.

License
-------

The MIT License (MIT)

Copyright (c) 2013 Fiore Basile <fiore.basile@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.



 