//
//  SensorUART.h
//  
//
//  Created by Fiore Basile on 03/12/13.
//
//


@interface SensorUART : NSObject

@property (nonatomic,assign)int writeCount;
@property (nonatomic,assign)int readCount;

-(uint8_t)read;
-(int)available;
-(void)write:(uint8_t*)bytes length:(int)len;

-(void)reset;
-(void)start;

@end
