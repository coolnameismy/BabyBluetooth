//
//  BabyPeripheralManager.h
//  BluetoothStubOnIOS
//
//  Created by 刘彦玮 on 15/12/12.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyToy.h"
#import "BabySpeaker.h"


@interface BabyPeripheralManager : NSObject<CBPeripheralManagerDelegate>{

@public
    //回叫方法
    BabySpeaker *babySpeaker;
}

/**
 添加服务
 */
-(BabyPeripheralManager *(^)(NSArray *array))addServices;
-(BabyPeripheralManager *(^)(CBMutableService *server))addService;

/**
启动广播
 */
-(BabyPeripheralManager *(^)())startAdvertising;

//外设管理器
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;
@property (nonatomic,strong) NSString *localName;
@property (nonatomic,strong) NSMutableArray *services;


@end



/**
 *  构造characteristic并加入service
 *  paramter for properties
 *	r                       CBCharacteristicPropertyRead
 *	w                       CBCharacteristicPropertyWrite
 *	n                       CBCharacteristicPropertyNotify
 *  default value is rw     Read-Write
 
 *  paramter for permissions:
 *	r                       Read-only.
 *	w                       Write-only.peripheral,
 *	R                       Readable by trusted devices.
 *	W                       Writeable by trusted devices.
 *  default value is rw     Read-Write
 */
void addCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *value,NSString *descriptors,NSString *permissions,NSString *descriptor);

NSString* genUUID();

CBMutableService* CBServiceMake(NSString *UUID);

