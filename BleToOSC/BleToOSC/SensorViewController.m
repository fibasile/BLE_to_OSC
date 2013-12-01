//
//  SensorViewController.m
//  BleToOSC
//
//  Created by Fiore Basile on 01/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "SensorViewController.h"

@interface SensorViewController ()

@property (assign) BOOL isScanning;
@property (assign) BOOL isConnected;

@end

@implementation SensorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib {
    
    [self.typeCombo removeAllItems];
    [self.typeCombo addItemWithTitle:@"BLE Mini"];
    [self.typeCombo addItemWithTitle:@"Xadow"];

    self.statusLabel.stringValue = @"Not connected";
    self.statsLabel.stringValue = @"0 packets received";
    
    self.isScanning = NO;
    self.isConnected = NO;
    
    
    self.sentPackets = 0;
    
    [self addObserver:self forKeyPath:@"sentPackets" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"isScanning" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sentPackets"]){
        self.statsLabel.stringValue =
        [NSString stringWithFormat:@"%d packets", self.sentPackets];
        
    } else {
        [self updateButton];
    }
}


- (void) updateButton {
    if (self.isScanning && !self.isConnected){
        self.statusLabel.stringValue = @"Scanning";
        [self.scanButton setTitle:@"Stop scanning"];
    } else if (!self.isScanning && !self.isConnected) {
        self.statusLabel.stringValue = @"Not connected";
        [self.scanButton setTitle:@"Start scanning"];
    } else if (!self.isScanning && self.isConnected){
        self.statusLabel.stringValue = @"Connected";

        [self.scanButton setTitle:@"Disconnect"];
    }
    
}


- (void) initSensor {
    
    self.sensorDevice = nil;

//    NSString* sensorModel = @"BLE Mini";
    
    NSString* sensorModel = [self.typeCombo titleOfSelectedItem];
    NSLog(@"Sensor model %@", sensorModel);
    
    if ([sensorModel isEqualToString:@"BLE Mini"]) {
    
    self.sensorDevice = [[SensorDevice alloc] initWithDeviceUUID:BLEMINI_DEVICE_UUID serviceUUID:BLEMINI_SERVICE_UUID readUUID:BLEMINI_READ_UUID notifyUUID:BLEMINI_NOTIFY_UUID];
        
    } else {
        
        self.sensorDevice = [[SensorDevice alloc] initWithDeviceUUID:XADOW_DEVICE_UUID serviceUUID:XADOW_SERVICE_UUID readUUID:XADOW_READ_UUID notifyUUID:XADOW_NOTIFY_UUID];
        
    }
    self.sensorDevice.delegate = self;

}

- (void)sensorDidRefreshBLE:(SensorDevice *)sender {
    
    if (![sender canScan]){
        
        
        NSAlert* alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"BLE is not supported"];
        [alert runModal];

        self.isScanning = NO;
    } else {
        if (sender.connectedServices.count > 0){
            // connected
            NSLog(@"Connected");
            self.isScanning = NO;
            self.isConnected = YES;
            
            self.firmata = [[SensorFirmata alloc] initWithUART:sender.uart];
            [self.firmata queryAccelerometer:^(int accel_x, int accel_y, int accel_z) {
                //                NSLog(@"Received accel data %d,%d, %d", accel_x,accel_y,accel_z);
                
                self.sentPackets ++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    __autoreleasing OSCMutableMessage* packet = [[OSCMutableMessage alloc] init];
                   
                    [packet addFloat:(accel_x + 1024.0f) / 2000.0f];
                    [packet addFloat:(accel_y + 1024.0f) / 2000.0f];
                    [packet addFloat: (accel_z + 1024.0f) / 2000.0f];
                    [self.consumer consumeOSCPacket:packet];
                });
                
            }];
            [self.firmata startLoop];
        } else {
            self.isConnected = NO;
            self.isScanning = NO;
 
            
            NSLog(@"Not connected");
            if (self.firmata){
                [self.firmata stopLoop];
                self.firmata = nil;
            }
        }
        
    }
    
}


-(IBAction)scanAction:(id)sender{
    
    if (!self.isScanning) {
        if (self.isConnected) {
           
            [self disconnectEverything:self];
        } else {
            [self initSensor];
            [self.sensorDevice startScanning];
            self.isScanning = YES;
        }
    } else {
        self.isScanning = NO;
        [self.sensorDevice stopScanning];
        self.sensorDevice.delegate = nil;
        self.sensorDevice = nil;
        
    }
    

}

-(void)disconnectEverything:(id)sender {
    if (self.isScanning){
        [self.sensorDevice stopScanning];
    }
    if (self.isConnected) {
        [self.firmata stopLoop];
        [self.firmata.uart reset];
    }
    [self.sensorDevice clearDevices];
    self.firmata = nil;
    
    self.isConnected = NO;
    self.isScanning = NO;

}


@end
