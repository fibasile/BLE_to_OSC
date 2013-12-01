//
//  OSCServerViewController.m
//  BleToOSC
//
//  Created by Fiore Basile on 01/12/13.
//  Copyright (c) 2013 Fiore Basile. All rights reserved.
//

#import "OSCServerViewController.h"


@interface OSCServerViewController ()

@end

@implementation OSCServerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib {
    self.sentPackets = 0;
    [self addObserver:self forKeyPath:@"sentPackets" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sentPackets"]){
        self.statsLabel.stringValue = [NSString stringWithFormat:@"%d packets sent", self.sentPackets];
    }
}


- (IBAction) sendAction:(id)sender {
    
    if (!self.connection) {
        self.connection = [[OSCConnection alloc] init];
        self.connection.delegate = self;
        NSError* error;
        
        NSString* hostName = self.addressField.stringValue;
        NSNumberFormatter* fmt = [[NSNumberFormatter alloc] init];
        NSNumber* port = [fmt numberFromString:self.portField.stringValue];
        
        
        [self.connection connectToHost:hostName port:port.intValue protocol:OSCConnectionUDP error:&error];
        if (error != nil) {
            
            NSLog(@"Failed to bind");
        } else {
            
            //        [self doStuff:self];
            
        }
    } else {

        [self.connection disconnect];
        self.connection = nil;
    }
    
}

-(void)consumeOSCPacket:(OSCPacket *)packet {
    if (self.connection){
        self.sentPackets++;
        OSCMutableMessage* msg = (OSCMutableMessage*)packet;
        NSString* path = self.pathField.stringValue;
        [msg setAddress:path];
        //[msg setAddress:@"/wii/0/classic/accel/xyz"];
        [self.connection sendPacket:msg];
    } else {
        NSLog(@"Discarding packet");
    }
    
}

-(void)oscConnectionDidConnect:(OSCConnection *)connection {
    NSLog(@"OSC Connected");
    self.sendButton.title = @"Stop sending";
}

-(void)oscConnectionDidDisconnect:(OSCConnection *)connection {
    NSLog(@"OSC Disconnected");
    self.sendButton.title = @"Start sending";
}


@end
