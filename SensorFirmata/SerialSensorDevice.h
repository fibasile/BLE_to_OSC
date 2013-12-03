//
//  SerialSensorDevice.h
//  BleToOSC
//
//  Created by Fiore Basile on 03/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorUART.h"
#import "SensorDevice.h"


@interface SerialSensorDevice : SensorDevice
-(id)initWithPort:(NSString*)port;
@property (nonatomic,retain) SensorUART* sensorUART;
@end
