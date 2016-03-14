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
    baby.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics()
    .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


//蓝牙网关初始化和委托方法设置
- (void)babyDelegate{
    
    __weak typeof(baby) weakBaby = baby;
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    
    //连接过滤器
    __block BOOL isFirst = YES;
    [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
       //这里的规则是：连接第一个设备
        isFirst = NO;
        return YES;
        //这里的规则是：连接第一个P打头的设备
//        if(isFirst && [peripheralName hasPrefix:@"“刘彦玮”"]){
//            isFirst = NO;
//            return YES;
//        }
//        return NO;
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

