//
//  BabyBlueDefine.h
//  BabyTestProject
//
//  Created by xuanyan.lyw on 16/4/19.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

//蓝牙系统通知

//centralManager status did change notification
#define BabyNotificationAtCentralManagerDidUpdateState @"BabyNotificationAtCentralManagerDidUpdateState"
//did discover peripheral notification
#define BabyNotificationAtDidDiscoverPeripheral @"BabyNotificationAtDidDiscoverPeripheral"
//did connection peripheral notification
#define BabyNotificationAtDidConnectPeripheral @"BabyNotificationAtDidConnectPeripheral"
//did filed connect peripheral notification
#define BabyNotificationAtDidFailToConnectPeripheral @"BabyNotificationAtDidFailToConnectPeripheral"
//did disconnect peripheral notification
#define BabyNotificationAtDidDisconnectPeripheral @"BabyNotificationAtDidDisconnectPeripheral"
//did discover service notification
#define BabyNotificationAtDidDiscoverServices @"BabyNotificationAtDidDiscoverServices"
//did discover characteristics notification
#define BabyNotificationAtDidDiscoverCharacteristicsForService @"BabyNotificationAtDidDiscoverCharacteristicsForService"
//did read or notify characteristic when received value  notification
#define BabyNotificationAtDidUpdateValueForCharacteristic @"BabyNotificationAtDidUpdateValueForCharacteristic"
//did write characteristic and response value notification
#define BabyNotificationAtDidWriteValueForCharacteristic @"BabyNotificationAtDidWriteValueForCharacteristic"
//did change characteristis notify status notification
#define BabyNotificationAtDidUpdateNotificationStateForCharacteristic @"BabyNotificationAtDidUpdateNotificationStateForCharacteristic"
//did read rssi and receiced value notification
#define BabyNotificationAtDidReadRSSI @"BabyNotificationAtDidReadRSSI"

//蓝牙扩展通知
// did centralManager enable notification
#define BabyNotificationAtCentralManagerEnable @"BabyNotificationAtCentralManagerEnable"

@interface BabyBlueDefine : NSObject

@end
