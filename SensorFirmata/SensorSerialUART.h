//
//  SensorSerialUART.h
//  BleToOSC
//
//  Created by Fiore Basile on 03/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "SensorUART.h"
#import "ORSSerialPort.h"
#import "ORSSerialPortManager.h"
#import "ADCircularBuffer.h"


@interface SensorSerialUART : SensorUART <ORSSerialPortDelegate> {
    ADCircularBuffer buffer;

}


@property (assign) ORSSerialPort* serialPort;
-(id)initWithPort:(NSString*)portname;

@end
