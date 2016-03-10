/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 
 @brief  babybluetooth 工具类
 
 */

//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>



@interface BabyToy : NSObject

//十六进制转换为普通字符串的。
+ (NSString *)ConvertHexStringToString:(NSString *)hexString;
//普通字符串转换为十六进制
+ (NSString *)ConvertStringToHexString:(NSString *)string;
//int转data
+(NSData *)ConvertIntToData:(int)i;
//data转int
+(int)ConvertDataToInt:(NSData *)data;
//十六进制转换为普通字符串的。
+ (NSData *)ConvertHexStringToData:(NSString *)hexString;
//根据UUIDString查找CBCharacteristic
+(CBCharacteristic *)findCharacteristicFormServices:(NSMutableArray *)services
                                         UUIDString:(NSString *)UUIDString;
@end
