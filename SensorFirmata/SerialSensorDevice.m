//
//  SerialSensorDevice.m
//  BleToOSC
//
//  Created by Fiore Basile on 03/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "SerialSensorDevice.h"
#import "SensorSerialUART.h"

@implementation SerialSensorDevice


-(id)initWithPort:(NSString*)port {
    if (self = [super init]){
        
        
        self.sensorUART = [[SensorSerialUART alloc] initWithPort:port];
        self.canScan = YES;
    }
    return self;
}

-(SensorUART*)uart {
    return self.sensorUART;
}

-(void)startScanning {
    [self.sensorUART start];
    [self.delegate sensorDidRefreshBLE:self];
}

@end
