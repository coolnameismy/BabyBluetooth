//
//  BabyBluetooth.h
//  
//
//  Created by 刘彦玮 on 15/3/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
// simple

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Babysister.h"
#import "BabyToy.h"
#import "BabySpeaker.h"



typedef NS_ENUM(NSInteger, BabyStatus) {
    BabyStatusStop = 0,
    BabyStatusRuning
};



@interface BabyBluetooth : NSObject

#pragma mark -属性 property



//从设备数组
@property (strong, nonatomic) NSMutableDictionary *peripherals;

//通知、委托、block处理
//@property (strong, nonatomic) Babysister *babysister;



//超时时间
#define BLEtTimeout 30




#pragma mark -设置委托方法

//设备状态改变的委托
-(void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block;
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;
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


//设置查找Peripherals的规则
-(void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName))filter;
//设置连接Peripherals的规则
-(void)setFilterOnConnetToPeripherals:(BOOL (^)(NSString *peripheralName))filter;



//channel
//设备状态改变的委托
-(void)setBlockOnCentralManagerDidUpdateStateOnChannel:(NSString *)channel
                                                        block:(void (^)(CBCentralManager *central))block;
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripheralsOnChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;

//连接Peripherals成功的委托
-(void)setBlockOnConnectedOnChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;

//设置查找服务回叫
-(void)setBlockOnDiscoverServicesOnChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block;

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristicsOnChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristicOnChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristicOnChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block;
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptorsOnChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block;

//设置查找Peripherals的规则
-(void)setFilterOnDiscoverPeripheralsOnChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName))filter;

//设置连接Peripherals的规则
-(void)setFilterOnConnetToPeripheralsOnChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName))filter;

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

//开始并执行sec秒后停止
//-(BabyBluetooth *(^)()) begin:(int)sec;

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


