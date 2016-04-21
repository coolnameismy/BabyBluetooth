//
//  BabybluetoothNotificationTest.m
//  BabyTestProject
//
//  Created by xuanyan.lyw on 16/4/20.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "BabyTestExpretaion.h"
#import "BabyBluetooth.h"


@interface BabybluetoothNotificationTest : XCTestCase

@property (nonatomic, strong) BabyBluetooth *baby;

@end

@implementation BabybluetoothNotificationTest

NSString * const testPeripleralName1 = @"BabyBluetoothTestStub";

- (void)setUp {
    [super setUp];
    self.baby = [BabyBluetooth shareBabyBluetooth];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 
 
 BabyNotificationAtDidFailToConnectPeripheral 不测试
 
 */
- (void)testExample {
    //蓝牙系统通知
    //[self expectationForNotification:(BabyNotificationAtCentralManagerDidUpdateState) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidDiscoverPeripheral) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidConnectPeripheral) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidDisconnectPeripheral) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidDiscoverServices) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidDiscoverCharacteristicsForService) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidWriteValueForCharacteristic) object:nil handler:nil];
    [self expectationForNotification:(BabyNotificationAtDidUpdateNotificationStateForCharacteristic) object:nil handler:nil];
    
    //无法测试的类型
    //    [self expectationForNotification:(BabyNotificationAtCentralManagerEnable) object:nil handler:nil];
    //    [self expectationForNotification:(BabyNotificationAtDidFailToConnectPeripheral) object:nil handler:nil];
     
    //设置扫描到设备的委托
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        NSLog(@"搜索到了设备:%@",localName);
        if ([localName isEqualToString:testPeripleralName1]) {
            return YES;
        }
        return NO;
    }];
    
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        for (CBCharacteristic *c in service.characteristics) {
            if (c.properties & CBCharacteristicPropertyWrite) {
                Byte b = 0X01;
                NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
                [peripheral writeValue:data forCharacteristic:c type:CBCharacteristicWriteWithResponse];
            }
            if (c.properties & CBCharacteristicPropertyNotify) {
                [peripheral setNotifyValue:YES forCharacteristic:c];
            }
        }
    }];
    
    self.baby.scanForPeripherals().enjoy().stop(10);
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
