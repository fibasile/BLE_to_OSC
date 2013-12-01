//
//  AppDelegate.h
//  BleToOSC
//
//  Created by Fiore Basile on 30/11/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SensorViewController.h"
#import "OSCServerViewController.h"

@class  OSCConnection;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet SensorViewController *sensorController;
@property (unsafe_unretained) IBOutlet OSCServerViewController *oscServerController;

@property (strong) OSCConnection *connection;
@end
