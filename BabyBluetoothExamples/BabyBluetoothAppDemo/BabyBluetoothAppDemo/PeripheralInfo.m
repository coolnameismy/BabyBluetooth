//
//  PeripheralInfo.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/6.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "PeripheralInfo.h"

@implementation PeripheralInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        _characteristics = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
