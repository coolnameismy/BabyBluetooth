//
//  CharacteristicViewController.h
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/8/7.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"


@interface CharacteristicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
@public
    BabyBluetooth *baby;
    NSMutableArray *sect;
  __block  NSMutableArray *readValueArray;
  __block  NSMutableArray *descriptors;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
