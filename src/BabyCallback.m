/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/9/2.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyCallback.h"

@implementation BabyCallback


-(instancetype)init{
    self = [super init];
    if (self){
        [self setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
            if(![peripheralName isEqualToString:@""])
                return YES;
            return NO;
        }];
        [self setFilterOnConnetToPeripherals:^BOOL(NSString *peripheralName) {
            if(![peripheralName isEqualToString:@""])
                return YES;
            return NO;
        }];
    }
    return self;
}
@end
