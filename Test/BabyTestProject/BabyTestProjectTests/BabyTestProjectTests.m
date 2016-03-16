//
//  BabyTestProjectTests.m
//  BabyTestProjectTests
//
//  Created by ZTELiuyw on 16/3/11.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BabyBluetooth.h"
#import "BabyTestExpretaion.h"

@interface BabyTestProjectTests : XCTestCase

@property (nonatomic, strong) BabyBluetooth *baby;
@property (nonatomic, strong) CBPeripheral *testPeripheral;

@end

NSString * const testPeripleralName = @"BabyBluetoothTestStub";

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
 ！！测试前必须先启动BabyTestStub项目
 
 执行顺序：启动->过滤扫描->扫描->过滤连接->连接->发现服务->发现特征->读取特征->读取特征的描述->读取Rssi->取消扫描->断开连接->结束
 */
- (void)testCentralModelMainOfDelegateAndFilter {
    
    __weak __typeof(self) weakSelf = self;
    
    BabyTestExpretaion *filterOnDiscoverPeripheralsExp = [self expWithDescription:@"filterOnDiscoverPeripherals not execute"];
    BabyTestExpretaion *blockOnDiscoverToPeripheralsExp = [self expWithDescription:@"blockOnDiscoverToPeripheralsExp not execute"];

    BabyTestExpretaion *filterOnConnectToPeripheralsExp = [self expWithDescription:@"filterOnConnectToPeripherals not execute"];
    BabyTestExpretaion *blockOnConnectedExp = [self expWithDescription:@"blockOnConnectedExp not execute"];

    BabyTestExpretaion *blockOnDiscoverServicesExp = [self expWithDescription:@"blockOnDiscoverServicesExp not execute"];
    BabyTestExpretaion *blockOnDiscoverCharacteristicsExp = [self expWithDescription:@"blockOnDiscoverCharacteristics not execute"];
    BabyTestExpretaion *blockOnReadValueForCharacteristicExp = [self expWithDescription:@"blockOnReadValueForCharacteristic not execute"];
  
    BabyTestExpretaion *blockOnDiscoverDescriptorsForCharacteristicExp = [self expWithDescription:@"blockOnDiscoverDescriptorsForCharacteristic not execute"];
    BabyTestExpretaion *blockOnReadValueForDescriptorsExp = [self expWithDescription:@"blockOnReadValueForDescriptors not execute"];
  
    BabyTestExpretaion *blockOnReadRSSIExp = [self expWithDescription:@"blockOnReadRSSI not execute"];

    BabyTestExpretaion *blockOnDisconnectExp = [self expWithDescription:@"blockOnDisconnect block not execute"];
    BabyTestExpretaion *blockOnCancelScanExp = [self expWithDescription:@"blockOnCancelScan block not execute"];
    BabyTestExpretaion *blockOnCancelAllPeripheralsConnectionExp = [self expWithDescription:@"blockOnCancelAllPeripheralsConnection block not execute"];

    //设置查找设备的过滤器
    //只放过测试peripheral名称相等的设备
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        NSLog(@"搜索到了设备:%@",localName);
        if ([localName isEqualToString:testPeripleralName]) {
            [filterOnDiscoverPeripheralsExp fulfill];
            return YES;
        }
        return NO;
    }];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        if ([localName isEqualToString:testPeripleralName]) {
            [blockOnDiscoverToPeripheralsExp fulfill];
            weakSelf.testPeripheral = peripheral;
        }else {
            //如果出现非测试程序的设备则出错
            [weakSelf failOnTest:@"filterOnDiscoverPeripherals 方法未进行有效的过滤"];
        }
    }];
    
    //设置连接设备的过滤器
    [self.baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        NSLog(@"连接设备的过滤器,设备:%@",localName);
        if ([localName isEqualToString:testPeripleralName]) {
            [filterOnConnectToPeripheralsExp fulfill];
            return YES;
        }
        return NO;
    }];
    
    //设置连接设备的委托
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        if (self.testPeripheral == peripheral) {
            [blockOnConnectedExp fulfill];
            //读取RSSI测试
            [weakSelf.testPeripheral readRSSI];
        } else {
            //如果出现非测试程序的设备则出错
            [weakSelf failOnTest:@"setBlockOnConnected 方法未进行有效的过滤"];
        }
    }];
    
    //设置发现设备的Services的委托
    [self.baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        [blockOnDiscoverServicesExp fulfill];
    }];

    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        [blockOnDiscoverCharacteristicsExp fulfill];
    }];

    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        [blockOnReadValueForCharacteristicExp fulfill];
    }];
  
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
        [blockOnDiscoverDescriptorsForCharacteristicExp fulfill];
    }];

    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        [blockOnReadValueForDescriptorsExp fulfill];
    }];

    //读取rssi的委托
    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
        [blockOnReadRSSIExp fulfill];
    }];

    //断开设备测试，读取rssi测试
    [self.baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
        [blockOnCancelScanExp fulfill];
    }];

    //断开连接委托
    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [blockOnDisconnectExp fulfill];
    }];
  
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
        [blockOnCancelAllPeripheralsConnectionExp fulfill];
    }];
  
    //启动中心设备
    self.baby.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin().stop(15);
  
    //预期
    [self waitForExpectationsWithTimeout:20 handler:nil];
  
    //无法模拟测试
    //
    //    //设置设备连接失败的委托
    //    [self.baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
    //        NSLog(@"设备：%@--连接失败",peripheral.name);
    //        [blockOnFailToConnectExp fulfill];
    //
    //    }];
    //
}


/**
 测试Peripheral断开后自动重连方法
 
 @method: (void)AutoReconnect:(CBPeripheral *)peripheral;//添加断开自动重连的外设
*/

- (void)testAutoReConnect {
    
    __weak __typeof(self) weakSelf = self;
    BabyTestExpretaion *blockOnDisconnectExp = [self expWithDescription:@"first disconnect block not execute"];
    BabyTestExpretaion *blockOnReConnectExp = [self expWithDescription:@"secend reconnect block not execute"];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"%@",peripheral.identifier);
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        if ([localName isEqualToString:testPeripleralName]) {
            NSLog(@"搜索到了设备:%@",peripheral.name);
        }
        
    }];
    //设置连接设备的过滤器
    [self.baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        NSLog(@"连接设备的过滤器,设备:%@",localName);
        if ([localName isEqualToString:testPeripleralName]) {
            return YES;
        }
        return NO;
    }];
    
    //设置连接的委托
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        if (blockOnDisconnectExp.hasFulfill) {
            NSLog(@"设备：%@--已重新连接，测试成功",peripheral.name);
            [blockOnReConnectExp fulfill];
            //清除自动重连接的状态
            [weakSelf.baby AutoReconnectCancel:peripheral];
        } else {
            NSLog(@"设备：%@--已连接",peripheral.name);
            //设置重新连接的设备
            [weakSelf.baby AutoReconnect:peripheral];
            NSLog(@"设备：--开始断开连接，测试重连功能");
            [weakSelf.baby cancelAllPeripheralsConnection];
        }
    }];
    
    //断开连接的委托
    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [blockOnDisconnectExp fulfill];
//        [weakSelf.baby.centralManager connectPeripheral:peripheral options:nil];
//        NSArray *array = [weakSelf.baby.centralManager retrievePeripheralsWithIdentifiers:@[peripheral.identifier]];
//        [weakSelf.baby.centralManager retrieveConnectedPeripheralsWithServices:nil];
    }];
    
    //启动中心设备
    self.baby.scanForPeripherals().connectToPeripherals().begin();
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

/**
 测试Peripheral操作的委托
 */
//- (void)testPeripheralOperationOfDelegate {
    //设置写数据成功的block
    //    [baby setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
    //        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    //    }];
    
    //设置通知状态改变的block
    //    [baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
    //        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    //    }];
    
//}


//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}


- (void)failOnTest:(NSString *)msg {
    XCTFail(@"%@",msg);
}

- (BabyTestExpretaion *)expWithDescription:(NSString *)description {
  BabyTestExpretaion *babyExp = [[BabyTestExpretaion alloc]initWithExp:[self expectationWithDescription:description]];
  return babyExp;
}

@end
