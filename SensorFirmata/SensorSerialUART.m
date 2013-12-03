//
//  SensorSerialUART.m
//  BleToOSC
//
//  Created by Fiore Basile on 03/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "SensorSerialUART.h"

@implementation SensorSerialUART

-(id)initWithPort:(NSString*)portname {

    if (self = [super init]){
        ORSSerialPortManager* mgr = [ORSSerialPortManager sharedSerialPortManager];
        for (ORSSerialPort* p in mgr.availablePorts){
            if ([p.path isEqualToString:portname]){
                self.serialPort = p;
                self.serialPort.delegate = self;
            }
        }
        self.readCount = 0;
        self.writeCount = 0;
        ADCircularBufferInit(&buffer,1024);
    }
    return self;
    
}
-(void)start {
    [self.serialPort open];
}

-(void)reset {
    [self.serialPort close];
}

-(uint8_t)read {
    // read from circular buffer
    ElemType elem;
    ADCircularBufferRead(&buffer, &elem);
    return elem.value;
}

-(int)available {
    // check circular buffer
    BOOL avail =  !ADCircularBufferIsEmpty(&buffer);
    
    return avail;
}

-(void)write:(uint8_t*)bytes length:(int)len {
    NSData* data = [NSData dataWithBytes:bytes length:len];
    [self.serialPort sendData:data];

}

-(void)appendBuffer:(uint8_t)byte{
    //    NSLog(@"append %02x", byte);
    // write to the tx characteritistic
    ElemType elem;
    elem.value =byte;
    ADCircularBufferWrite(&buffer, &elem);
}

-(void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
//    NSData* data = characteristic.value;
    self.readCount+=data.length;
    uint8_t* buff = malloc(sizeof(uint8_t) * data.length);
    [data getBytes:buff length:data.length];
    for (int i=0;i<data.length;i++){
        [self appendBuffer:buff[i]];
    }
    free(buff);

}

-(void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error {
    
}

-(void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    
}

-(void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    
}
-(void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    
}
@end
