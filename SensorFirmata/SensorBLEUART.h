//
//  SensorUART.h
//
//  Created by fiore on 04/11/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import "ADCircularBuffer.h"
#import "SensorUART.h"

@class BLESensorDevice;


@interface SensorBLEUART : SensorUART <CBPeripheralDelegate> {
    ADCircularBuffer buffer;
}

@property (nonatomic,strong) CBPeripheral* device;
@property (nonatomic,strong) CBService* service;
@property (nonatomic,readonly) CBUUID* serviceUUID;
@property (nonatomic,readonly) CBUUID* readUUID;
@property (nonatomic,readonly) CBUUID* writeNotifyUUID;
@property(strong,nonatomic) CBCharacteristic *cbReadWriteCharacteristic;
@property(strong,nonatomic) CBCharacteristic *cbNotifyCharacteristic;



-initWithPeripheral:(CBPeripheral*)device serviceUUID:(NSString*) serviceUUID readUUID:(NSString*)readUUID writeNotifyUUID:(NSString*)writeNotifyUUID;



@end
