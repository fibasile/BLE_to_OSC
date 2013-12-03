//
//  XadowPeripheral.h
//  XadowDashboard
//
//  Created by fiore on 04/11/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import "SensorBLEUART.h"

#define XADOW_DEVICE_UUID @"58808941-83FE-473C-F95D-340B6DA1272B"
#define XADOW_SERVICE_UUID @"FFF0"
#define XADOW_READ_UUID @"FFF1"
#define XADOW_NOTIFY_UUID @"FFF2"

#define BLEMINI_DEVICE_UUID @"4E3E6654-F76B-4CFA-AD25-F0630EBD2DE8"
#define BLEMINI_SERVICE_UUID @"713D0000-503E-4C75-BA94-3148F18D941E"
#define BLEMINI_READ_UUID @"713D0003-503E-4C75-BA94-3148F18D941E"
#define BLEMINI_NOTIFY_UUID @"713D0002-503E-4C75-BA94-3148F18D941E"





#import "SensorDevice.h"

@interface BLESensorDevice : SensorDevice <CBCentralManagerDelegate>

@property (strong) NSString* pDeviceUUID;
@property (strong) NSString* pServiceUUID;
@property (strong) NSString* pReadUUID;
@property (strong) NSString* pNotifyUUID;



@property (nonatomic,strong) CBCentralManager* centralManager;
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray    *connectedServices;
@property (nonatomic,readonly) CBUUID* deviceUUID;
@property (nonatomic,readonly) NSArray* servicesUUID;

- (id)initWithDeviceUUID:(NSString*)deviceUUID serviceUUID:(NSString*)serviceUUID readUUID:(NSString*)readUUID notifyUUID:(NSString*)notifiyUUID;


@end
