//
//  BabySpeaker.m
//  BabyBluetoothDemo
//
//  Created by 刘彦玮 on 15/9/2.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabySpeaker.h"


//找到设备的委托
typedef void (^BBDiscoverPeripheralsBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);
//连接设备成功的block
typedef void (^BBConnectedPeripheralBlock)(CBCentralManager *central,CBPeripheral *peripheral);
//连接设备失败的block
typedef void (^BBFailToConnectBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//断开设备连接的bock
typedef void (^BBDisconnectBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//找到服务的block
typedef void (^BBDiscoverServicesBlock)(CBPeripheral *peripheral,NSError *error);
//找到Characteristics的block
typedef void (^BBDiscoverCharacteristicsBlock)(CBPeripheral *peripheral,CBService *service,NSError *error);
//更新（获取）Characteristics的value的block
typedef void (^BBReadValueForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);
//获取Characteristics的名称
typedef void (^BBDiscoverDescriptorsForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error);
//获取Descriptors的值
typedef void (^BBReadValueForDescriptorsBlock)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error);


typedef NS_ENUM(NSUInteger, BabySpeakerType) {
    BabySpeakerTypeDiscoverPeripherals,
    BabySpeakerTypeConnectedPeripheral,
    BabySpeakerTypeDiscoverPeripheralsFailToConnect,
    BabySpeakerTypeDiscoverPeripheralsDisconnect,
    BabySpeakerTypeDiscoverPeripheralsDiscoverServices,
    BabySpeakerTypeDiscoverPeripheralsDiscoverCharacteristics,
    BabySpeakerTypeDiscoverPeripheralsReadValueForCharacteristic,
    BabySpeakerTypeDiscoverPeripheralsDiscoverDescriptorsForCharacteristic,
    BabySpeakerTypeDiscoverPeripheralsReadValueForDescriptorsBlock
};

//默认channel名称
#define defaultChannel @"babyDefault"

@implementation BabySpeaker{
    //所有委托频道
    NSMutableDictionary *channels;
    //当前委托频道
    NSString *currChannel;
    //notifyList
    NSMutableDictionary *notifyList;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        BabyCallback *defaultCallback = [[BabyCallback alloc]init];
        notifyList = [[NSMutableDictionary alloc]init];
        channels = [[NSMutableDictionary alloc]init];
        currChannel = defaultChannel;
        [channels setObject:defaultCallback forKey:defaultChannel];
    }
    return self;
}

-(BabyCallback *)callback{
    return [channels objectForKey:defaultChannel];
}

-(BabyCallback *)callbackOnCurrChannel {
//    [self callbackOnChnnel:currChannel];
    return [self callbackOnChnnel:currChannel];
}

-(BabyCallback *)callbackOnChnnel:(NSString *)channel{
    if (!channel) {
        [self callback];
    }
    return [channels objectForKey:channel];
}

-(BabyCallback *)callbackOnChnnel:(NSString *)channel
               createWhenNotExist:(BOOL)createWhenNotExist{
    
    BabyCallback *callback = [channels objectForKey:channel];
    if (!callback && createWhenNotExist){
        callback = [[BabyCallback alloc]init];
        [channels setObject:callback forKey:channel];
    }
    
    return callback;
}


-(void)switchChannel:(NSString *)channel{
    if (channel) {
        if ([self callbackOnChnnel:channel]) {
            currChannel = channel;
            NSLog(@">>>已切换到%@",channel);
        }
        else{
            NSLog(@">>>所要切换的channel不存在");
        }
    }else{
        currChannel = defaultChannel;
            NSLog(@">>>已切换到默认频道");
    }
    
    
}

//添加到notify list
-(void)addNotifyCallback:(CBCharacteristic *)c
           withBlock:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block{
    [notifyList setObject:block forKey:c.UUID.description];
}

//添加到notify list
-(void)removeNotifyCallback:(CBCharacteristic *)c{
    [notifyList removeObjectForKey:c.UUID.description];
}

//获取notify list
-(NSMutableDictionary *)notifyCallBackList{
    return notifyList;
}

//获取notityBlock
-(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))notifyCallback:(CBCharacteristic *)c{
    return [notifyList objectForKey:c.UUID.description];
}
@end
