//
//  SimpleBLENotifiyHandler.h
//  PlantAssistant
//
//  Created by ZTELiuyw on 15/7/30.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyToy.h"


@interface Babysister : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>{

@public

    //方法是否处理
    BOOL needScanForPeripherals;//是否扫描Peripherals
    BOOL needConnectPeripheral;//是否连接Peripherals
    BOOL needDiscoverServices;//是否发现Services
    BOOL needDiscoverCharacteristics;//是否获取Characteristics
    BOOL needUpdateValueForCharacteristic;//是否获取（更新）Characteristics的值
    
    //方法执行时间
    int executeTime;
    NSTimer *connectTimer;
    //pocket
    NSMutableDictionary *pocket;
    
    //委托方法 callback block
    BBDiscoverPeripheralsBlock blockOnDiscoverPeripherals;//发现peripherals
    BBConnectedPeripheralBlock blockOnConnectedPeripheral; //连接callback
    BBDiscoverServicesBlock blockOnDiscoverServices; //发现services
    BBDiscoverCharacteristicsBlock blockOnDiscoverCharacteristics; //发现Characteristics
    BBUpdateValueForCharacteristicBlock blockOnUpdateValueForCharacteristic;//发现更新Characteristics的value
    
    //过滤器Filter
    BOOL (^filterOnConnetToPeripherals)(NSString *peripheralsFilter);    //发现peripherals规则
    BOOL (^filterOnDiscoverPeripherals)(NSString *peripheralsFilter);    //连接peripherals规则
    
@private
    NSMutableDictionary *peripherals;
  
}



////连接Peripherals成功的委托
//-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;
////找到Peripherals的委托
//-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
////设置查找服务回叫
//-(void)setBlockOndDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block;
//
////设置连接Peripherals的规则
//-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter;
////设置查找Peripherals的规则
//-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter;


@end



