//
//  BabyTestProjectTests.m
//  BabyTestProjectTests
//
//  Created by ZTELiuyw on 16/3/11.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BabyBluetooth.h"

@interface BabyTestProjectTests : XCTestCase

@property (nonatomic, strong) BabyBluetooth *baby;

@end

@implementation BabyTestProjectTests

- (void)setUp {
    [super setUp];
    self.baby = [BabyBluetooth shareBabyBluetooth];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - unit test

/**
 test centralManager and peripheralManager can power on
*/
- (void)testCentralManagerAndPeripheralManagerCanPowerOn {
    
    XCTestExpectation *cmExprect = [self expectationWithDescription:@"centralManager can't power on"];
    XCTestExpectation *pmExprect = [self expectationWithDescription:@"peripheralManager can't power on"];
    
    if (self.baby.centralManager.state == CBPeripheralManagerStatePoweredOn) {
        [cmExprect fulfill];
    }
    
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [cmExprect fulfill];
        }
    }];
    
    if (self.baby.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [pmExprect fulfill];
    }
    [self.baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
        if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
            [pmExprect fulfill];
        }
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
    
}

/**
 测试链式方法中心模式主要的委托和过滤器
 ！！测试前必须 依赖于周围有ble4.0设备并发出广播
 */
- (void)testCentralModelMainOfDelegateAndFilter {
    
    XCTestExpectation *blockOnDiscoverToPeripheralsExp = [self expectationWithDescription:@"blockOnDiscoverToPeripheralsExp not execute"];
//    XCTestExpectation *blockOnDiscoverServicesExp = [self expectationWithDescription:@"blockOnDiscoverServicesExp not execute"];
//    XCTestExpectation *blockOnDiscoverCharacteristicsExp = [self expectationWithDescription:@"blockOnDiscoverCharacteristics not execute"];
//    XCTestExpectation *blockOnReadValueForCharacteristicExp = [self expectationWithDescription:@"blockOnReadValueForCharacteristic not execute"];
//    XCTestExpectation *blockOnDiscoverDescriptorsForCharacteristicExp = [self expectationWithDescription:@"blockOnDiscoverDescriptorsForCharacteristic not execute"];
    
//    XCTestExpectation *blockOnReadValueForDescriptorsExp = [self expectationWithDescription:@"blockOnReadValueForDescriptors not execute"];
//    XCTestExpectation *blockOnReadRSSIExp = [self expectationWithDescription:@"blockOnReadRSSI not execute"];
//    XCTestExpectation *blockOnFailToConnectExp = [self expectationWithDescription:@"blockOnFailToConnect not execute"];
//    XCTestExpectation *blockOnDisconnectExp = [self expectationWithDescription:@"blockOnDisconnect block not execute"];
    
    XCTestExpectation *filterOnDiscoverPeripheralsExp = [self expectationWithDescription:@"filterOnDiscoverPeripherals not execute"];
    XCTestExpectation *filterOnConnectToPeripheralsExp = [self expectationWithDescription:@"ilterOnConnectToPeripherals not execute"];
    
    //设置扫描到设备的委托w
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [blockOnDiscoverToPeripheralsExp fulfill];
    }];
    
    //设置发现设备的Services的委托
//    [self.baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
//        for (CBService *service in peripheral.services) {
//            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
//        }
//        [blockOnDiscoverServicesExp fulfill];
//    }];
//    
//    //设置发现设service的Characteristics的委托
//    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
//        NSLog(@"===service name:%@",service.UUID);
//        for (CBCharacteristic *c in service.characteristics) {
//            NSLog(@"charateristic name is :%@",c.UUID);
//        }
//        [blockOnDiscoverCharacteristicsExp fulfill];
//    }];
//    
//    //设置读取characteristics的委托
//    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
//        [blockOnReadValueForCharacteristicExp fulfill];
//    }];
//    
//    //设置发现characteristics的descriptors的委托
//    [self.baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
//        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
//        for (CBDescriptor *d in characteristic.descriptors) {
//            NSLog(@"CBDescriptor name is :%@",d.UUID);
//        }
//        [blockOnDiscoverDescriptorsForCharacteristicExp fulfill];
//    }];
//    
//    //设置读取Descriptor的委托
//    [self.baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
//        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
//        [blockOnReadValueForDescriptorsExp fulfill];
//    }];
//
//    //读取rssi的委托
//    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
//        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
//        [blockOnReadRSSIExp fulfill];
//    }];
//    
//    //设置设备连接失败的委托
//    [self.baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        NSLog(@"设备：%@--连接失败",peripheral.name);
//        [blockOnFailToConnectExp fulfill];
//        
//    }];
//    
//    //设置设备断开连接的委托
//    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        NSLog(@"设备：%@--断开连接",peripheral.name);
//        [blockOnDisconnectExp fulfill];
//    }];
    
    //设置查找设备的过滤器
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        [filterOnDiscoverPeripheralsExp fulfill];
        return YES;
    }];
    
    //设置连接设备的过滤器
    [self.baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        [filterOnConnectToPeripheralsExp fulfill];
        return YES;
    }];
    
    
    //启动中心设备
    self.baby.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics().discoverDescriptorsForCharacteristic().readValueForCharacteristic().readValueForDescriptors().begin();
    
    //断开设备测试，读取rssi测试
    
    
    //预期
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
//    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
//        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
//    }];
//    
//    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
//        NSLog(@"setBlockOnCancelScanBlock");
//    }];
    
}


/**
 测试Peripheral操作的委托
 */
- (void)testPeripheralOperationOfDelegate {
    //设置写数据成功的block
    //    [baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
    //        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    //    }];
    
    //设置通知状态改变的block
    //    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
    //        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    //    }];
    
}
 

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
