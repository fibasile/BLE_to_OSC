//
//  SensorDevice.h
//  
//
//  Created by Fiore Basile on 03/12/13.
//
//

#import <Foundation/Foundation.h>
#import "SensorUART.h"

@protocol SensorRefreshDelegate

-(void)sensorDidRefreshBLE:(id)sender;

@end

@interface SensorDevice : NSObject
@property (nonatomic,assign) id<SensorRefreshDelegate> delegate;
@property (nonatomic,assign) BOOL canScan;

-(BOOL)isConnected;
-(void)startScanning;
-(void)stopScanning;
-(SensorUART*)uart;
- (void) clearDevices;
@end
