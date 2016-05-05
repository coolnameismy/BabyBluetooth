/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 
@brief  预定义一些库的执行行为和配置
 
 */

// Created by 刘彦玮 on 6/4/19.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//  

#import <Foundation/Foundation.h>


# pragma mark - baby 行为定义

//Baby if show log 是否打印日志，默认1：打印 ，0：不打印
#define KBABY_IS_SHOW_LOG 1

//CBcentralManager等待设备打开次数
# define KBABY_CENTRAL_MANAGER_INIT_WAIT_TIMES 5

//CBcentralManager等待设备打开间隔时间
# define KBABY_CENTRAL_MANAGER_INIT_WAIT_SECOND 2.0

//BabyRhythm默认心跳时间间隔
#define KBABYRHYTHM_BEATS_DEFAULT_INTERVAL 3;

//Baby默认链式方法channel名称
#define KBABY_DETAULT_CHANNEL @"babyDefault"

# pragma mark - baby通知

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



# pragma mark - baby 定义的方法

//Baby log
#define BabyLog(fmt, ...) if(KBABY_IS_SHOW_LOG) { NSLog(fmt,##__VA_ARGS__); }





@interface BabyDefine : NSObject

@end
