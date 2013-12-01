//
//  XadowFirmata.h
//  XadowDashboard
//
//  Created by fiore on 04/11/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Foundation/Foundation.h>



@class SensorUART;

@interface SensorFirmata : NSObject

@property (nonatomic,strong) NSThread* bgThread;
@property (nonatomic,strong) SensorUART* uart;

- (id)initWithUART:(SensorUART*)uart;
- (void)queryFirmware;
- (void)queryAccelerometer:(void(^)(int accel_x, int accel_y, int accel_z))accelBlock;
- (void) startLoop;
- (void) stopLoop;
@end
