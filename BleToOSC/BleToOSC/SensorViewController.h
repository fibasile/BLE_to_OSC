//
//  SensorViewController.h
//  BleToOSC
//
//  Created by Fiore Basile on 01/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SensorDevice.h"
#import "SensorFirmata.h"
#import "SensorPacketConsumer.h"

@interface SensorViewController : NSViewController <SensorRefreshDelegate>
@property (strong) SensorDevice *sensorDevice;
@property (strong) SensorFirmata *firmata;
@property (weak) IBOutlet id<SensorPacketConsumer> consumer;
@property (weak) IBOutlet NSPopUpButton *typeCombo;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSTextField *statsLabel;
@property (weak) IBOutlet NSButton *scanButton;

@property (assign) int sentPackets;

-(IBAction)scanAction:(id)sender;
-(void)disconnectEverything:(id)sender;
@end
