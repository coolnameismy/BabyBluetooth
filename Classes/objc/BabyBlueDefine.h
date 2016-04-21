//
//  BabyBlueDefine.h
//  BabyTestProject
//
//  Created by xuanyan.lyw on 16/4/19.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

//蓝牙系统通知
#define BabyNotificationAtCentralManagerDidUpdateState @"BabyNotificationAtCentralManagerDidUpdateState"
#define BabyNotificationAtDidDiscoverPeripheral @"BabyNotificationAtDidDiscoverPeripheral"
#define BabyNotificationAtDidConnectPeripheral @"BabyNotificationAtDidConnectPeripheral"
#define BabyNotificationAtDidFailToConnectPeripheral @"BabyNotificationAtDidFailToConnectPeripheral"
#define BabyNotificationAtDidDisconnectPeripheral @"BabyNotificationAtDidDisconnectPeripheral"
#define BabyNotificationAtDidDiscoverServices @"BabyNotificationAtDidDiscoverServices"
#define BabyNotificationAtDidDiscoverCharacteristicsForService @"BabyNotificationAtDidDiscoverCharacteristicsForService"
#define BabyNotificationAtDidUpdateValueForCharacteristic @"BabyNotificationAtDidUpdateValueForCharacteristic"
#define BabyNotificationAtDidWriteValueForCharacteristic @"BabyNotificationAtDidWriteValueForCharacteristic"
#define BabyNotificationAtDidUpdateNotificationStateForCharacteristic @"BabyNotificationAtDidUpdateNotificationStateForCharacteristic"
#define BabyNotificationAtDidReadRSSI @"BabyNotificationAtDidReadRSSI"

//蓝牙扩展通知
#define BabyNotificationAtCentralManagerEnable @"BabyNotificationAtCentralManagerEnable"

@interface BabyBlueDefine : NSObject

@end
