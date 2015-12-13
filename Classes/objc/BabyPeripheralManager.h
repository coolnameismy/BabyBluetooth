//
//  BabyPeripheralManager.h
//  BluetoothStubOnIOS
//
//  Created by 刘彦玮 on 15/12/12.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface BabyPeripheralManager : NSObject<CBPeripheralManagerDelegate>





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
@property (nonatomic,strong) NSMutableArray *services;
@property (nonatomic,strong) NSString *localName;




@end



/**
 构建characteristic
 
 permissions:r,w,R,W
 r: Read-only.
 w: Write-only.
 R: Readable by trusted devices.
 W: Writeable by trusted devices.
 
 */
void addCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *value,NSString *descriptors,NSString *permissions,NSString *descriptor);


CBMutableService* CBServiceMake(NSString *UUID);

