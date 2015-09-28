//
//  BabyClothes.m
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/9/27.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import "BabyOptions.h"

@implementation BabyOptions

-(instancetype)init{
    self = [super init];
    if(self){
        [self setScanForPeripheralsWithOptions:nil];
        [self setConnectPeripheralWithOptions:nil];
        [self setScanForPeripheralsWithServices:nil];
        [self setDiscoverWithCharacteristics:nil];
        [self setDiscoverWithServices:nil];
    }
    return self;
}

-(instancetype)initWithscanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions
        connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions
{
    self = [super init];
    if(self){
        [self setScanForPeripheralsWithOptions:scanForPeripheralsWithOptions];
        [self setConnectPeripheralWithOptions:connectPeripheralWithOptions];
    }
    return self;
}

-(instancetype)initWithscanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions
                        connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions
                      scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                      discoverWithServices:(NSArray *)discoverWithServices
                      discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics
{
    self = [self initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectPeripheralWithOptions];
    if(self){
        [self setScanForPeripheralsWithServices:scanForPeripheralsWithServices];
        [self setDiscoverWithServices:discoverWithServices];
        [self setDiscoverWithCharacteristics:discoverWithCharacteristics];
    }
    return self;
}



@end
