//
//  PeripheralInfo.h
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/6.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralInfo : NSObject

@property (nonatomic,strong) CBUUID *serviceUUID;
@property (nonatomic,strong) NSMutableArray *characteristics;

@end
