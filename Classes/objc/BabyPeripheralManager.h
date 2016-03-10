/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 
 @brief  蓝牙外设模式实现类
 
 */


//  Created by 刘彦玮 on 15/12/12.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyToy.h"
#import "BabySpeaker.h"


@interface BabyPeripheralManager : NSObject<CBPeripheralManagerDelegate> {

@public
    //回叫方法
    BabySpeaker *babySpeaker;
}

/**
 添加服务
 */
- (BabyPeripheralManager *(^)(NSArray *array))addServices;

/**
启动广播
 */
- (BabyPeripheralManager *(^)())startAdvertising;

//外设管理器
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, copy) NSString *localName;
@property (nonatomic, strong) NSMutableArray *services;

@end


/**
 *  构造Characteristic，并加入service
 *  service:CBService
 
 *  param`ter for properties ：option 'r' | 'w' | 'n' or combination
 *	r                       CBCharacteristicPropertyRead
 *	w                       CBCharacteristicPropertyWrite
 *	n                       CBCharacteristicPropertyNotify
 *  default value is rw     Read-Write

 *  paramter for descriptor：be uesd descriptor for characteristic
 */

void makeCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *properties,NSString *descriptor);

/**
 *  构造一个包含初始值的Characteristic，并加入service,包含了初值的characteristic必须设置permissions和properties都为只读
 *  make characteristic then add to service, a static characteristic mean it has a initial value .according apple rule, it must set properties and permissions to CBCharacteristicPropertyRead and CBAttributePermissionsReadable
*/
void makeStaticCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *descriptor,NSData *data);
/**
 生成CBService
 */
CBMutableService* makeCBService(NSString *UUID);

/**
 生成UUID
 */
NSString* genUUID();
