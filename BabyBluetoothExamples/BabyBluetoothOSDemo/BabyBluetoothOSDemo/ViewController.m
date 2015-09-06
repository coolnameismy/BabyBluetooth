//
//  ViewController.m
//  BabyBluetoothOSDemo
//
//  Created by liuyanwei on 15/9/6.
//  Copyright (c) 2015年 liuyanwei. All rights reserved.
//

#import "ViewController.h"
#import "BabyBluetooth.h"

@implementation ViewController{
    BabyBluetooth *baby;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    __weak typeof(baby) weakBaby = baby;
    //因为蓝牙设备打开需要时间，所以只有监听到蓝牙设备状态打开后才能安全的使用蓝牙
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            //设置peripheral 然后读取services,然后读取characteristics名称和值和属性，获取characteristics对应的description的名称和值
            weakBaby.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics()
            .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
        }
    }];
}


//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(baby) weakBaby = baby;
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length >2) {
            return YES;
        }
        return NO;
    }];
    
    //连接过滤器
    __block BOOL isFirst = YES;
    [baby setFilterOnConnetToPeripherals:^BOOL(NSString *peripheralName) {
        //这里的规则是：连接第一个P打头的设备
        if(isFirst && [peripheralName hasPrefix:@"P"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        //设置连接成功的block
        NSLog(@"设备：%@--连接成功",peripheral.name);
        //停止扫描
        [weakBaby cancelScan];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    
}

@end

