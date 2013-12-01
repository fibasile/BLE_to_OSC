//
//  SensorPacketConsumer.h
//  BleToOSC
//
//  Created by Fiore Basile on 01/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCPacket.h"

@protocol SensorPacketConsumer <NSObject>

- (void) consumeOSCPacket:(OSCPacket*)packet;

@end
