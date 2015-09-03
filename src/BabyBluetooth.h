//
//  GAAT.h
//  PlantAssistant
//
//  Created by 刘彦玮 on 15/3/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
// simple

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BBCentralManager.h"
#import "Babysister.h"
#import "BabyToy.h"
#import "BabySpeaker.h"



typedef NS_ENUM(NSInteger, BabyStatus) {
    BabyStatusStop = 0,
    BabyStatusRuning
};



@interface BabyBluetooth : NSObject{
    
@private
    //BabyStatus;
    BabyStatus babyStatus;
    BabySpeaker *babySpeaker;
    
}

#pragma mark -属性 property



//从设备数组
@property (strong, nonatomic) NSMutableDictionary *peripherals;

//通知、委托、block处理
//@property (strong, nonatomic) Babysister *babysister;



//超时时间
#define BLEtTimeout 30




#pragma mark -设置委托方法

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
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter;
//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter;


//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block
                               channel:(NSString *)channel;

//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block
                   channel:(NSString *)channel;

//设置查找服务回叫
-(void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block
                          channel:(NSString *)channel;

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block
                                 channel:(NSString *)channel;
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block
                                    channel:(NSString *)channel;
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block
                                              channel:(NSString *)channel;
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block
                                 channel:(NSString *)channel;


//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter
                            channel:(NSString *)channel;

//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter
                           channel:(NSString *)channel;


#pragma mark -链式函数
//查找Peripherals
-(BabyBluetooth *(^)()) scanForPeripherals;
//连接Peripherals
-(BabyBluetooth *(^)()) connectToPeripherals;
-(BabyBluetooth *(^)(CBPeripheral *peripheral)) connectToPeripheral;
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

//更新Characteristics的值
-(BabyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) fetchCharacteristicDetails;

//开始执行
-(BabyBluetooth *(^)()) begin;

//开始并执行sec秒后停止
//-(BabyBluetooth *(^)()) begin:(int)sec;

//sec秒后停止
-(void(^)(int sec)) stop;


/**
 切换委托的频道
 @parameter channel 频道名称，nil为默认频道
 */
-(void(^)(NSString *channel)) channel;


-(BabyBluetooth *) and;
-(BabyBluetooth *) then;



//读取Characteristic的详细信息
//-(BabyBluetooth *(^)())CharacteristicInfo:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic;
//

/**
 * 单例构造方法
 * @return SimpleBLE共享实例
 */
+(instancetype)shareSimpleBLE;



#pragma mark -测试使用

/**
 *  测试
 */


@end


