/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 
 version:0.7.0
 */

// Created by 刘彦玮 on 15/3/31.
// Copyright (c) 2015年 刘彦玮. All rights reserved.



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyCentralManager.h"
#import "BabyPeripheralManager.h"
#import "BabyToy.h"
#import "BabySpeaker.h"
#import "BabyRhythm.h"
#import "BabyDefine.h"


@interface BabyBluetooth : NSObject

#pragma mark - babybluetooth的委托

//默认频道的委托

/**
设备状态改变的block |  when CentralManager state changed
*/
- (void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block;

/**
 找到Peripherals的block |  when find peripheral
 */
- (void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;

/**
连接Peripherals成功的block
|  when connected peripheral 
*/
- (void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;

/**
连接Peripherals失败的block
|  when fail to connect peripheral 
*/
- (void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

/**
断开Peripherals的连接的block
|  when disconnected peripheral 
*/
- (void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

/**
设置查找服务的block
|  when discover services of peripheral 
*/
- (void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block;

/**
设置查找到Characteristics的block
|  when discovered Characteristics 
*/
- (void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;

/**
设置获取到最新Characteristics值的block
|  when read new characteristics value  or notiy a characteristics value 
*/
- (void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;

/**
设置查找到Descriptors名称的block
|  when discover descriptors for characteristic 
*/
- (void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;

/**
设置读取到Descriptors值的block
|  when read descriptors for characteristic 
*/
- (void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block;

/**
写Characteristic成功后的block
|  when did write value for characteristic successed 
*/
- (void)setBlockOnDidWriteValueForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block;

/**
写descriptor成功后的block
|  when did write value for descriptor successed 
*/
- (void)setBlockOnDidWriteValueForDescriptor:(void (^)(CBDescriptor *descriptor,NSError *error))block;

/**
characteristic订阅状态改变的block
|  when characteristic notification state changed 
*/
- (void)setBlockOnDidUpdateNotificationStateForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block;

/**
读取RSSI的委托
|  when did read RSSI 
*/
- (void)setBlockOnDidReadRSSI:(void (^)(NSNumber *RSSI,NSError *error))block;

/**
discoverIncludedServices的回调，暂时在babybluetooth中无作用
|  no used in babybluetooth 
*/
- (void)setBlockOnDidDiscoverIncludedServicesForService:(void (^)(CBService *service,NSError *error))block;

/**
外设更新名字后的block
|  when peripheral update name 
*/
- (void)setBlockOnDidUpdateName:(void (^)(CBPeripheral *peripheral))block;

/**
外设更新服务后的block
|  when peripheral update services 
*/
- (void)setBlockOnDidModifyServices:(void (^)(CBPeripheral *peripheral,NSArray *invalidatedServices))block;



// channel的委托

/**
设备状态改变的block
|  when CentralManager state changed 
*/
- (void)setBlockOnCentralManagerDidUpdateStateAtChannel:(NSString *)channel
                                                 block:(void (^)(CBCentralManager *central))block;
/**
找到Peripherals的block
|  when find peripheral 
*/
- (void)setBlockOnDiscoverToPeripheralsAtChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;


/**
连接Peripherals成功的block
|  when connected peripheral 
*/
- (void)setBlockOnConnectedAtChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;


/**
连接Peripherals失败的block
|  when fail to connect peripheral 
*/
- (void)setBlockOnFailToConnectAtChannel:(NSString *)channel
                                  block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

/**
断开Peripherals的连接的block
|  when disconnected peripheral 
*/
- (void)setBlockOnDisconnectAtChannel:(NSString *)channel
                               block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;


/**
设置查找服务的block
|  when discover services of peripheral 
*/
- (void)setBlockOnDiscoverServicesAtChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block;

/**
设置查找到Characteristics的block
|  when discovered Characteristics 
*/
- (void)setBlockOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;

/**
设置获取到最新Characteristics值的block
|  when read new characteristics value  or notiy a characteristics value 
*/
- (void)setBlockOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;

/**
设置查找到Characteristics描述的block
|  when discover descriptors for characteristic 
*/
- (void)setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block;

/**
设置读取到Characteristics描述的值的block
|  when read descriptors for characteristic 
*/
- (void)setBlockOnReadValueForDescriptorsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block;


/**
写Characteristic成功后的block
|  when did write value for characteristic successed 
*/
- (void)setBlockOnDidWriteValueForCharacteristicAtChannel:(NSString *)channel
                                                   block:(void (^)(CBCharacteristic *characteristic,NSError *error))block;

/**
写descriptor成功后的block
|  when did write value for descriptor successed 
*/
- (void)setBlockOnDidWriteValueForDescriptorAtChannel:(NSString *)channel
                                               block:(void (^)(CBDescriptor *descriptor,NSError *error))block;


/**
characteristic订阅状态改变的block
|  when characteristic notification state changed 
*/
- (void)setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:(NSString *)channel
                                                                block:(void (^)(CBCharacteristic *characteristic,NSError *error))block;

/**
读取RSSI的委托
|  when did read RSSI 
*/
- (void)setBlockOnDidReadRSSIAtChannel:(NSString *)channel
                                block:(void (^)(NSNumber *RSSI,NSError *error))block;

/**
discoverIncludedServices的回调，暂时在babybluetooth中无作用
|  no used in babybluetooth 
*/
- (void)setBlockOnDidDiscoverIncludedServicesForServiceAtChannel:(NSString *)channel
                                                          block:(void (^)(CBService *service,NSError *error))block;

/**
外设更新名字后的block
|  when peripheral update name 
*/
- (void)setBlockOnDidUpdateNameAtChannel:(NSString *)channel
                                  block:(void (^)(CBPeripheral *peripheral))block;

/**
外设更新服务后的block
|  when peripheral update services 
*/
- (void)setBlockOnDidModifyServicesAtChannel:(NSString *)channel
                                      block:(void (^)(CBPeripheral *peripheral,NSArray *invalidatedServices))block;


#pragma mark - babybluetooth filter

/**
设置查找Peripherals的规则
|  filter of discover peripherals 
*/
- (void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter;

/**
设置连接Peripherals的规则
|  setting filter of connect to peripherals  peripherals 
*/
- (void)setFilterOnConnectToPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter;


/**
设置查找Peripherals的规则
|  filter of discover peripherals 
*/
- (void)setFilterOnDiscoverPeripheralsAtChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter;

/**
设置连接Peripherals的规则
|  setting filter of connect to peripherals  peripherals 
*/
- (void)setFilterOnConnectToPeripheralsAtChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter;


#pragma mark - babybluetooth Special

/**
babyBluettooth cancelScan方法调用后的回调
|  when after call cancelScan 
*/
- (void)setBlockOnCancelScanBlock:(void(^)(CBCentralManager *centralManager))block;

/**
babyBluettooth cancelAllPeripheralsConnectionBlock 方法执行后并且全部设备断开后的回调
|  when did all peripheral disConnect 
*/
- (void)setBlockOnCancelAllPeripheralsConnectionBlock:(void(^)(CBCentralManager *centralManager))block;

/**
babyBluettooth cancelScan方法调用后的回调
|  when after call cancelScan 
*/
- (void)setBlockOnCancelScanBlockAtChannel:(NSString *)channel
                                         block:(void(^)(CBCentralManager *centralManager))block;

/**
babyBluettooth cancelAllPeripheralsConnectionBlock 方法执行后并且全部设备断开后的回调
|  when did all peripheral disConnect 
*/
- (void)setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:(NSString *)channel
                                                             block:(void(^)(CBCentralManager *centralManager))block;

/**
设置蓝牙运行时的参数
|  set ble runtime parameters 
*/
- (void)setBabyOptionsWithScanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
                          connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
                        scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                                  discoverWithServices:(NSArray *)discoverWithServices
                           discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics;

/**
设置蓝牙运行时的参数
|  set ble runtime parameters 
*/
- (void)setBabyOptionsAtChannel:(NSString *)channel
 scanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
  connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
          discoverWithServices:(NSArray *)discoverWithServices
   discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics;


#pragma mark - 链式函数

/**
查找Peripherals
 */
- (BabyBluetooth *(^)()) scanForPeripherals;

/**
连接Peripherals
 */
- (BabyBluetooth *(^)()) connectToPeripherals;

/**
发现Services
 */
- (BabyBluetooth *(^)()) discoverServices;

/**
获取Characteristics
 */
- (BabyBluetooth *(^)()) discoverCharacteristics;

/**
更新Characteristics的值
 */
- (BabyBluetooth *(^)()) readValueForCharacteristic;

/**
获取Characteristics的名称
 */
- (BabyBluetooth *(^)()) discoverDescriptorsForCharacteristic;

/**
获取Descriptors的值
 */
- (BabyBluetooth *(^)()) readValueForDescriptors;

/**
开始执行
 */
- (BabyBluetooth *(^)()) begin;

/**
sec秒后停止
 */
- (BabyBluetooth *(^)(int sec)) stop;

/**
持有对象
 */
- (BabyBluetooth *(^)(id obj)) having;

/**
切换委托的频道
 */
- (BabyBluetooth *(^)(NSString *channel)) channel;

/**
谓词，返回self
 */
- (BabyBluetooth *) and;
/**
谓词，返回self
 */
- (BabyBluetooth *) then;
/**
谓词，返回self
 */
- (BabyBluetooth *) with;

/**
 * enjoy 祝你使用愉快，
 *
 *   说明：enjoy是蓝牙全套串行方法的简写（发现服务，发现特征，读取特征，读取特征描述），前面可以必须有scanForPeripherals或having方法，channel可以选择添加。
     
    enjoy() 等同于 connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    
    它可以让你少敲很多代码
 
     ## 例子：
     - 扫描后来个全套（发现服务，发现特征，读取特征，读取特征描述）
     
     ` baby.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics()
     .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
     `
     
     - 直接使用已有的外设连接后全套（发现服务，发现特征，读取特征，读取特征描述）

     ` baby.having(self.peripheral).connectToPeripherals().discoverServices().discoverCharacteristics()
     .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
 `
 enjoy后面也可以加stop()方法
 
 */

- (BabyBluetooth *(^)()) enjoy;

#pragma mark - 工具方法

/**
 * 单例构造方法
 * @return BabyBluetooth共享实例
 */
+ (instancetype)shareBabyBluetooth;


/**
断开连接
 */
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

/**
断开所有连接
 */
- (void)cancelAllPeripheralsConnection;

/**
停止扫描
 */
- (void)cancelScan;

/**
更新Characteristics的值
 */
- (BabyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) characteristicDetails;

/**
设置characteristic的notify
 */
- (void)notify:(CBPeripheral *)peripheral
characteristic:(CBCharacteristic *)characteristic
         block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;

/**
取消characteristic的notify
 */
- (void)cancelNotify:(CBPeripheral *)peripheral
     characteristic:(CBCharacteristic *)characteristic;

/**
获取当前连接的peripherals
 */
- (NSArray *)findConnectedPeripherals;

/**
获取当前连接的peripheral
 */
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName;

/**
获取当前corebluetooth的centralManager对象
 */
- (CBCentralManager *)centralManager;

/**
 添加断开自动重连的外设
 */
- (void)AutoReconnect:(CBPeripheral *)peripheral;

/**
 删除断开自动重连的外设
 */
- (void)AutoReconnectCancel:(CBPeripheral *)peripheral;

/**
 根据外设UUID对应的string获取已配对的外设
 
 通过方法获取外设后可以直接连接外设，跳过扫描过程
 */
- (CBPeripheral *)retrievePeripheralWithUUIDString:(NSString *)UUIDString;


#pragma mark - peripheral model

//进入外设模式
- (BabyPeripheralManager *(^)()) bePeripheral;
- (BabyPeripheralManager *(^)(NSString *localName)) bePeripheralWithName;

@property (nonatomic, readonly) CBPeripheralManager *peripheralManager;

//peripheral model block

/**
 PeripheralManager did update state block
 */
- (void)peripheralModelBlockOnPeripheralManagerDidUpdateState:(void(^)(CBPeripheralManager *peripheral))block;
/**
 PeripheralManager did add service block
 */
- (void)peripheralModelBlockOnDidAddService:(void(^)(CBPeripheralManager *peripheral,CBService *service,NSError *error))block;
/**
 PeripheralManager did start advertising block
 */
- (void)peripheralModelBlockOnDidStartAdvertising:(void(^)(CBPeripheralManager *peripheral,NSError *error))block;
/**
 peripheralManager did receive read request block
 */
- (void)peripheralModelBlockOnDidReceiveReadRequest:(void(^)(CBPeripheralManager *peripheral,CBATTRequest *request))block;
/**
 peripheralManager did receive write request block
 */
- (void)peripheralModelBlockOnDidReceiveWriteRequests:(void(^)(CBPeripheralManager *peripheral,NSArray *requests))block;
/**
 peripheralManager did subscribe to characteristic block
 */
- (void)peripheralModelBlockOnDidSubscribeToCharacteristic:(void(^)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic))block;
/**
peripheralManager did subscribe to characteristic block
*/
- (void)peripheralModelBlockOnDidUnSubscribeToCharacteristic:(void(^)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic))block;

@end


