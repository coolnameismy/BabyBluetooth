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

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
