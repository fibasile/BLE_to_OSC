//
//  OSCServerViewController.h
//  BleToOSC
//
//  Created by Fiore Basile on 01/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SensorPacketConsumer.h"
#import "OSCConnection.h"

@interface OSCServerViewController : NSViewController <SensorPacketConsumer, OSCConnectionDelegate>
@property (weak) IBOutlet NSTextField *addressField;
@property (weak) IBOutlet NSTextField *portField;
@property (weak) IBOutlet NSTextField *pathField;
@property (weak) IBOutlet NSTextField *statsLabel;

- (IBAction)sendAction:(id)sender;
@property (weak) IBOutlet NSButton *sendButton;
@property (assign) int sentPackets;
@property (strong) OSCConnection* connection;
@end
