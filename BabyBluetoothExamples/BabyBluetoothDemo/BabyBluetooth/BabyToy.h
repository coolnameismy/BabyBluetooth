//
//  BabyToy.h
//  BabyBluetoothDemo
//
//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//找到设备的委托
typedef void (^BBDiscoverPeripheralsBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);
//连接设备成功的block
typedef void (^BBConnectedPeripheralBlock)(CBCentralManager *central,CBPeripheral *peripheral);
//连接设备失败的block
typedef void (^BBFailToConnectBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//断开设备连接的bock
typedef void (^BBDisconnectBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//找到服务的block
typedef void (^BBDiscoverServicesBlock)(CBPeripheral *peripheral,NSError *error);
//找到Characteristics的block
typedef void (^BBDiscoverCharacteristicsBlock)(CBPeripheral *peripheral,CBService *service,NSError *error);
//更新（获取）Characteristics的value的block
typedef void (^BBUpdateValueForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);


@interface BabyToy : NSObject

@end
