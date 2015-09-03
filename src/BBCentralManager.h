//
//  SBCentralManager.h
//  PlantAssistant
//
//  Created by 刘彦玮 on 15/7/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface BBCentralManager : CBCentralManager





/** 扫描Peripherals */
-(void)scanForPeripherals;
/** 停止Peripherals */
-(void) stopScan:(id)sender;


@end
