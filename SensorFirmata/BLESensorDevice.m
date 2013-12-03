//
//  XadowPeripheral.m
//  XadowDashboard
//
//  Created by fiore on 04/11/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "BLESensorDevice.h"

static BLESensorDevice* _sensor;



@implementation BLESensorDevice

+(BLESensorDevice*)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sensor = [[BLESensorDevice alloc] init];
    });
    return _sensor;
}


- (id)initWithDeviceUUID:(NSString*)deviceUUID serviceUUID:(NSString*)serviceUUID readUUID:(NSString*)readUUID notifyUUID:(NSString*)notifiyUUID
{
    self = [super init];
    if (self) {
        
        self.pDeviceUUID = deviceUUID;
        self.pServiceUUID = serviceUUID;
        self.pReadUUID = readUUID;
        self.pNotifyUUID = notifiyUUID;
        
        NSDictionary* opts = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey
                              , nil];
        
        self.canScan = NO;
        self.delegate=nil;
        dispatch_queue_t queue = dispatch_queue_create("sensor.central.queue", DISPATCH_QUEUE_CONCURRENT);
        
        NSLog(@"Central Manager init");
        self.connectedServices = [NSMutableArray array];
        self.foundPeripherals = [NSMutableArray array];
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:opts];
    }
    return self;
}

- (void) dealloc
{
    // We are a singleton and as such, dealloc shouldn't be called.
//    assert(NO);
}


-(BOOL)isConnected {
    return self.connectedServices.count > 0;
}

-(CBUUID*) deviceUUID {
//    return [CBUUID UUIDWithString:@"58808941-83FE-473C-F95D-340B6DA1272B"];
    return [CBUUID UUIDWithString:self.pDeviceUUID];
}
-(NSArray*) servicesUUID {
//    return [NSArray arrayWithObject:[CBUUID UUIDWithString:@"fff0"]];
    return [NSArray arrayWithObject:[CBUUID UUIDWithString:self.pServiceUUID]];
}


-(void)notifyDelegate {
    if (self.delegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate sensorDidRefreshBLE:self];
        });
    }
}

#pragma mark Known devices cache

-(void)loadSavedDevice {
    
    NSArray *storedDevices  = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"No stored array to load");
        return;
    }
    
    for (id deviceUUIDString in storedDevices) {
        
        if (![deviceUUIDString isKindOfClass:[NSString class]])
            continue;
        
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:deviceUUIDString];
        if (!uuid)
            continue;
        
        [self.centralManager retrievePeripheralsWithIdentifiers:[NSArray arrayWithObject:(id)uuid]];
    }
    
}


- (void) saveDeviceWithIdentifier:(NSUUID*) uuid
{
    NSArray         *storedDevices  = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray  *newDevices     = nil;
    
    if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"Can't find/create an array to store the uuid");
        storedDevices = [NSArray array];
    }
    
    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    
    [newDevices addObject:uuid.description];
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) removeSavedDevice:(NSUUID*) uuid
{
    NSArray         *storedDevices  = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray  *newDevices     = nil;

    
    if ([storedDevices isKindOfClass:[NSArray class]]) {
        newDevices = [NSMutableArray arrayWithArray:storedDevices];
        
        [newDevices removeObject:uuid];
        /* Store */
        [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark action

-(SensorBLEUART*)uart {
    
    if (self.connectedServices.count > 0){
        return (SensorBLEUART*)[self.connectedServices lastObject];
    }
    return nil;
}

-(void)startScanning {
    NSLog(@"Start scanning..");
        NSDictionary    *options    = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        [self.centralManager scanForPeripheralsWithServices:nil options:options];
   
}
- (void) stopScanning
{
    [self.centralManager stopScan];
}


- (void) clearDevices
{
    
    for (CBPeripheral* p in self.foundPeripherals){
        if (p.state == CBPeripheralStateConnected || p.state == CBPeripheralStateConnecting){
            [self disconnectPeripheral:p];
        }
    }
    
    [self.foundPeripherals removeAllObjects];
    
    for (SensorBLEUART* service in self.connectedServices) {
        [service reset];
    }
    [self.connectedServices removeAllObjects];
}


- (void) connectPeripheral:(CBPeripheral*)peripheral
{
    if ([peripheral state] != CBPeripheralStateConnected || [peripheral state] != CBPeripheralStateConnecting) {
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    [self.centralManager cancelPeripheralConnection:peripheral];
}





#pragma mark CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"Updated state");
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        self.canScan = YES;
        [self loadSavedDevice];
        [central retrieveConnectedPeripheralsWithServices:self.servicesUUID];
        
        
    }  else if (central.state < CBCentralManagerStatePoweredOn) {
            //  scanning has stopped and that any connected peripherals have been disconnected
             [self clearDevices];
    } else if (central.state <= CBCentralManagerStatePoweredOff ) {
             [self clearDevices];
            // cbcentral manager is not ready or not available
        NSAlert* alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"This device doesn't support BLE, or app is not authorized to use it"];
        [alert runModal];
        
    }
    [self notifyDelegate];
    
}

-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    CBPeripheral    *peripheral;
    
    /* Add to list. */
    for (peripheral in peripherals) {
        [self connectPeripheral:peripheral];
    }
    
    [self notifyDelegate];
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    CBPeripheral    *peripheral;
    
    /* Add to list. */
    for (peripheral in peripherals) {
        [self connectPeripheral:peripheral];
    }
    [self notifyDelegate];
    
}

-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict {
    
    
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Did discover peripheral %@", peripheral);
    
    
 
    
    if (![self.foundPeripherals containsObject:peripheral]) {
        [self.foundPeripherals addObject:peripheral];
        [self notifyDelegate];
        if ([[CBUUID UUIDWithNSUUID:peripheral.identifier].data isEqual:self.deviceUUID.data]){
            NSLog(@"Found sensor device");
            [self connectPeripheral:peripheral];
        }
    }
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
      NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
    [self removeSavedDevice:peripheral.identifier];
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {

    
    [self stopScanning];
    
    [self saveDeviceWithIdentifier:peripheral.identifier];

    NSLog(@"device connected");

    SensorBLEUART   *service    = nil;
    
    /* Create a service instance. */
    service = [[SensorBLEUART alloc] initWithPeripheral:peripheral serviceUUID:self.pServiceUUID readUUID:self.pReadUUID writeNotifyUUID:self.pNotifyUUID];
    [service start];
    
    if (![self.connectedServices containsObject:service])
        [self.connectedServices addObject:service];
    
    if ([self.foundPeripherals containsObject:peripheral])
        [self.foundPeripherals addObject:peripheral];
    

    [self notifyDelegate];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    SensorBLEUART   *service    = nil;
    
    NSLog(@"device disconnected");
    
    for (service in self.connectedServices) {
        if ([service device] == peripheral) {
            [self.connectedServices removeObject:service];
            break;
        }
    }
    if ([self.foundPeripherals containsObject:peripheral])
        [self.foundPeripherals removeObject:peripheral];

    
    [self notifyDelegate];
    
}


 
@end
