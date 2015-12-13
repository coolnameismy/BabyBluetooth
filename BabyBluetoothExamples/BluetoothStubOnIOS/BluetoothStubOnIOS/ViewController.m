//
//  ViewController.m
//  BluetoothStubOnIOS
//
//  Created by 刘彦玮 on 15/12/11.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import "ViewController.h"
#import "BabyBluetooth.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    BabyBluetooth *baby = [BabyBluetooth shareBabyBluetooth];

    CBMutableService *s1 = CBServiceMake(@"FFF0");
    addCharacteristicToService(s1,@"FFF1", @"", @"r", @"r", @"hello1");
    addCharacteristicToService(s1,@"FFF2", @"", @"r", @"r", @"hello2");
    
//    baby.bePeripheral().addService(s1).startAdvertising();
    baby.bePeripheral().addServices(@[s1]).startAdvertising();
    

}


@end
