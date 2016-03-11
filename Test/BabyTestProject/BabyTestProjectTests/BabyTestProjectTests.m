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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

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

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
