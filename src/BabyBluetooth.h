/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

// Created by 刘彦玮 on 15/3/31.
// Copyright (c) 2015年 刘彦玮. All rights reserved.



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Babysister.h"
#import "BabyToy.h"
#import "BabySpeaker.h"
#import "BabyRhythm.h"



@interface BabyBluetooth : NSObject

#pragma mark -babybluetooth的委托
/* 
    默认频道的委托
 */
//设备状态改变的委托
-(void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block;
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;
//连接Peripherals失败的委托
-(void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;
//断开Peripherals的连接
-(void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;
//设置查找服务回叫
-(void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block;
//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//设置查找到Descriptors名称的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//设置读取到Descriptors值的block
-(void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block;

/*
 channel的委托
 */
//设备状态改变的委托
-(void)setBlockOnCentralManagerDidUpdateStateAtChannel:(NSString *)channel
                                                 block:(void (^)(CBCentralManager *central))block;
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripheralsAtChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;

//连接Peripherals成功的委托
-(void)setBlockOnConnectedAtChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;

//连接Peripherals失败的委托
-(void)setBlockOnFailToConnectAtChannel:(NSString *)channel
                                  block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

//断开Peripherals的连接
-(void)setBlockOnDisconnectAtChannel:(NSString *)channel
                               block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

//设置查找服务回叫
-(void)setBlockOnDiscoverServicesAtChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block;

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block;
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptorsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block;


#pragma mark -babybluetooth filter委托
//设置查找Peripherals的规则
-(void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName))filter;
//设置连接Peripherals的规则
-(void)setFilterOnConnetToPeripherals:(BOOL (^)(NSString *peripheralName))filter;


//设置查找Peripherals的规则
-(void)setFilterOnDiscoverPeripheralsAtChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName))filter;

//设置连接Peripherals的规则
-(void)setFilterOnConnetToPeripheralsAtChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName))filter;


#pragma mark -babybluetooth Special
//babyBluettooth cancelScan方法调用后的回调
-(void)setBlockOnCancelScanBlock:(void(^)(CBCentralManager *centralManager))block;
//babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
-(void)setBlockOnCancelAllPeripheralsConnectionBlock:(void(^)(CBCentralManager *centralManager))block;
//babyBluettooth cancelPeripheralConnection 方法调用后的回调
-(void)setBlockOnCancelPeripheralConnectionBlock:(void(^)(CBCentralManager *centralManager,CBPeripheral *peripheral))block;

//babyBluettooth cancelScan方法调用后的回调
-(void)setBlockOnCancelScanBlockAtChannel:(NSString *)channel
                                         block:(void(^)(CBCentralManager *centralManager))block;
//babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
-(void)setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:(NSString *)channel
                                                             block:(void(^)(CBCentralManager *centralManager))block;
//babyBluettooth cancelPeripheralConnection 方法调用后的回调
-(void)setBlockOnCancelPeripheralConnectionBlockAtChannel:(NSString *)channel
                                                         block:(void(^)(CBCentralManager *centralManager,CBPeripheral *peripheral))block;

//设置蓝牙运行时的参数
-(void)setBabyOptionsWithScanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
                          connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
                        scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                                  discoverWithServices:(NSArray *)discoverWithServices
                           discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics;
//设置蓝牙运行时的参数
-(void)setBabyOptionsAtChannel:(NSString *)channel
 scanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
  connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
          discoverWithServices:(NSArray *)discoverWithServices
   discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics;


#pragma mark -链式函数
//查找Peripherals
-(BabyBluetooth *(^)()) scanForPeripherals;
//连接Peripherals
-(BabyBluetooth *(^)()) connectToPeripherals;
//发现Services
-(BabyBluetooth *(^)()) discoverServices;
//获取Characteristics
-(BabyBluetooth *(^)()) discoverCharacteristics;
//更新Characteristics的值
-(BabyBluetooth *(^)()) readValueForCharacteristic;
//获取Characteristics的名称
-(BabyBluetooth *(^)()) discoverDescriptorsForCharacteristic;
//获取Descriptors的值
-(BabyBluetooth *(^)()) readValueForDescriptors;
//开始执行
-(BabyBluetooth *(^)()) begin;
//sec秒后停止
-(BabyBluetooth *(^)(int sec)) stop;
//持有对象
-(BabyBluetooth *(^)(id obj)) having;
//切换委托的频道
-(BabyBluetooth *(^)(NSString *channel)) channel;
//谓词，返回self
-(BabyBluetooth *) and;
-(BabyBluetooth *) then;
-(BabyBluetooth *) with;

#pragma mark -工具方法
//断开连接
-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral;
//断开所有连接
-(void)cancelAllPeripheralsConnection;
//停止扫描
-(void)cancelScan;
//更新Characteristics的值
-(BabyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) characteristicDetails;
//设置characteristic的notify
-(void)notify:(CBPeripheral *)peripheral
characteristic:(CBCharacteristic *)characteristic
         block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;
//取消characteristic的notify
-(void)cancelNotify:(CBPeripheral *)peripheral
     characteristic:(CBCharacteristic *)characteristic;


/**
 * 单例构造方法
 * @return BabyBluetooth共享实例
 */
+(instancetype)shareBabyBluetooth;

@end


