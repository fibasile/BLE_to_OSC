//
//  AppDelegate.m
//  BleToOSC
//
//  Created by Fiore Basile on 30/11/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "AppDelegate.h"
#import "SensorDevice.h"
#import "OSCPacket.h"
#import "OSCConnection.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    
    [self.sensorController disconnectEverything:self];
}

@end
