//
//  PeripheralViewContriller.h
//  BabyBluetoothDemo
//
//  Created by 刘彦玮 on 15/8/4.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"
#import "CharacteristicViewController.h"


@interface PeripheralViewController : UITableViewController{
    @public
    BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
