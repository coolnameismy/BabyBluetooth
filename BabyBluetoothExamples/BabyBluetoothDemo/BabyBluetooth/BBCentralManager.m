//
//  SBCentralManager.m
//  PlantAssistant
//
//  Created by ZTELiuyw on 15/7/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BBCentralManager.h"

@implementation BBCentralManager{
    
}

-(instancetype)initWithDelegate:(id<CBCentralManagerDelegate>)delegate queue:(dispatch_queue_t)queue{
    
    self = [super initWithDelegate:delegate queue:queue];
    if (self) {
       
    }
    return self;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)scanForPeripherals{

        if ([self state] != CBCentralManagerStatePoweredOn) {
            NSLog(@"CoreBluetooth is not correctly initialized");
        }
    
        [self scanForPeripheralsWithServices:nil options:0];
        //超时停止扫描
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopScan:) userInfo:nil repeats:NO];
        //发出通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"scanForPeripherals" object:nil];
}

//停止扫描
-(void) stopScan:(id)sender
{
    [self stopScan];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stopScan" object:nil];
}




@end
