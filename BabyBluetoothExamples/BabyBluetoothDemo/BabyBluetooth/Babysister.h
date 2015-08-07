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
    BOOL needReadValueForCharacteristic;//是否获取（更新）Characteristics的值
    BOOL needDiscoverDescriptorsForCharacteristic;//是否获取Characteristics的描述
    BOOL needReadValueForDescriptors;//是否获取Descriptors的值
    
 
    
    //委托方法 callback block
    BBDiscoverPeripheralsBlock blockOnDiscoverPeripherals;//发现peripherals
    BBConnectedPeripheralBlock blockOnConnectedPeripheral; //连接callback
    BBDiscoverServicesBlock blockOnDiscoverServices; //发现services
    BBDiscoverCharacteristicsBlock blockOnDiscoverCharacteristics; //发现Characteristics
    BBReadValueForCharacteristicBlock blockOnReadValueForCharacteristic;//发现更新Characteristics的value
    BBDiscoverDescriptorsForCharacteristicBlock blockOnDiscoverDescriptorsForCharacteristic;//获取Characteristics的名称
    BBReadValueForDescriptorsBlock blockOnReadValueForDescriptors;//获取Descriptors的值
    
    
    
    //过滤器Filter
    BOOL (^filterOnConnetToPeripherals)(NSString *peripheralsFilter);    //发现peripherals规则
    BOOL (^filterOnDiscoverPeripherals)(NSString *peripheralsFilter);    //连接peripherals规则
    
    
    
    //方法执行时间
    int executeTime;
    NSTimer *connectTimer;
    //pocket
    NSMutableDictionary *pocket;
    //已经连接的设备
    NSMutableArray *connectedPeripherals;
    
    //主设备
    CBCentralManager *bleManager;
    
@private
    NSMutableDictionary *peripherals;
  
}



//扫描Peripherals
-(void)scanPeripherals;
//连接Peripherals
-(void)connectToPeripheral:(CBPeripheral *)peripheral;
//断开所以已连接的设备
-(void)stopConnectAllPerihperals;
//停止扫描
-(void)stopScan;

@end



