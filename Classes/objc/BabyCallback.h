/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/9/2.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyOptions.h"


//设备状态改变的委托
typedef void (^BBcentralManagerDidUpdateStateBlock)(CBCentralManager *central);
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
typedef void (^BBReadValueForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);
//获取Characteristics的名称
typedef void (^BBDiscoverDescriptorsForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error);
//获取Descriptors的值
typedef void (^BBReadValueForDescriptorsBlock)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error);

//babyBluettooth cancelScanBlock方法调用后的回调
typedef void (^BBCancelScanBlock)(CBCentralManager *centralManager);
//babyBluettooth cancelAllPeripheralsConnection 方法调用后的回调
typedef void (^BBCancelAllPeripheralsConnectionBlock)(CBCentralManager *centralManager);
//babyBluettooth cancelPeripheralConnectionBlock 方法调用后的回调
typedef void (^BBCancelPeripheralConnectionBlock)(CBCentralManager *centralManager,CBPeripheral *peripheral);

@interface BabyCallback : NSObject

#pragma mark -callback block
//设备状态改变的委托
@property(nonatomic,strong) BBcentralManagerDidUpdateStateBlock blockOnCentralManagerDidUpdateState;
//发现peripherals
@property(nonatomic,strong) BBDiscoverPeripheralsBlock blockOnDiscoverPeripherals;
//连接callback
@property(nonatomic,strong) BBConnectedPeripheralBlock blockOnConnectedPeripheral;
//连接设备失败的block
@property(nonatomic,strong) BBFailToConnectBlock blockOnFailToConnect;
//断开设备连接的bock
@property(nonatomic,strong) BBDisconnectBlock blockOnDisconnect;
 //发现services
@property(nonatomic,strong) BBDiscoverServicesBlock blockOnDiscoverServices;
//发现Characteristics
@property(nonatomic,strong) BBDiscoverCharacteristicsBlock blockOnDiscoverCharacteristics;
//发现更新Characteristics的
@property(nonatomic,strong)  BBReadValueForCharacteristicBlock blockOnReadValueForCharacteristic;
//获取Characteristics的名称
@property(nonatomic,strong)  BBDiscoverDescriptorsForCharacteristicBlock blockOnDiscoverDescriptorsForCharacteristic;
//获取Descriptors的值
@property(nonatomic,strong)  BBReadValueForDescriptorsBlock blockOnReadValueForDescriptors;

//babyBluettooth stopScan方法调用后的回调
@property(nonatomic,strong)  BBCancelScanBlock blockOnCancelScan;
//babyBluettooth stopConnectAllPerihperals 方法调用后的回调
@property(nonatomic,strong)  BBCancelAllPeripheralsConnectionBlock blockOnCancelAllPeripheralsConnection;
//babyBluettooth cancelPeripheralConnection 方法调用后的回调
@property(nonatomic,strong)  BBCancelPeripheralConnectionBlock blockOnCancelPeripheralConnection;
//babyBluettooth 蓝牙使用的参数参数
@property(nonatomic,strong) BabyOptions *babyOptions;

#pragma mark -过滤器Filter
//发现peripherals规则
@property(nonatomic,strong)  BOOL (^filterOnConnetToPeripherals)(NSString *peripheralName);
//连接peripherals规则
@property(nonatomic,strong)  BOOL (^filterOnDiscoverPeripherals)(NSString *peripheralName);


@end
