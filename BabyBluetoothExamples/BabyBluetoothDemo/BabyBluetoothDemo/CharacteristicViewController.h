//
//  CharacteristicViewController.h
//  BabyBluetoothDemo
//
//  Created by ZTELiuyw on 15/8/7.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"


@interface CharacteristicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;
@property (nonatomic,strong)BabyBluetooth *baby;

@end
