//
//  Babysister.m
//
//  Created by 刘彦玮 on 15/7/30.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//
/*
 后续更新：
 1：补全所有委托转block
 2: 每个事件增加对NSNotificationCenter 的支持
 */

#import "Babysister.h"
#import "BabyCallback.h"

@implementation Babysister

//#define blockOnDiscoverPeripherals [[babySpeaker callbackOnCurrChannel] blockOnDiscoverPeripherals]
//#define  filterOnDiscoverPeripherals [[babySpeaker callbackOnCurrChannel] filterOnDiscoverPeripherals]
//#define filterOnConnetToPeripherals [[babySpeaker callbackOnCurrChannel]filterOnConnetToPeripherals]
//#define blockOnConnectedPeripheral [[babySpeaker callbackOnCurrChannel]blockOnConnectedPeripheral]
#define currChannel [babySpeaker callbackOnCurrChannel]


-(instancetype)init{
    self = [super init];
    if(self){
        //pocket
        pocket = [[NSMutableDictionary alloc]init];
        connectedPeripherals = [[NSMutableArray alloc]init];
        bleManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
        
        //监听通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scanForPeripheralNotifyReceived:) name:@"scanForPeripherals" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverPeripheralNotifyReceived:) name:@"didDiscoverPeripheral" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectToPeripheralNotifyReceived:) name:@"connectToPeripheral" object:nil];
        
    }
    return  self;
}




#pragma mark -接收到通知

//开始扫描
-(void)scanForPeripheralNotifyReceived:(NSNotification *)notify{
//    NSLog(@">>>scanForPeripheralsNotifyReceived");
}

//扫描到设备
-(void)didDiscoverPeripheralNotifyReceived:(NSNotification *)notify{
//    CBPeripheral *peripheral =[notify.userInfo objectForKey:@"peripheral"];
//    NSLog(@">>>didDiscoverPeripheralNotifyReceived:%@",peripheral.name);
}

//开始连接设备
-(void)connectToPeripheralNotifyReceived:(NSNotification *)notify{
//    NSLog(@">>>connectToPeripheralNotifyReceived");
}

//扫描Peripherals
-(void)scanPeripherals{
    [bleManager scanForPeripheralsWithServices:nil options:nil];
}
//连接Peripherals
-(void)connectToPeripheral:(CBPeripheral *)peripheral{
    [bleManager connectPeripheral:peripheral options:nil];
    //

}

//断开所以已连接的设备
-(void)stopConnectAllPerihperals{
    for (int i=0;i<connectedPeripherals.count;i++) {
        [bleManager cancelPeripheralConnection:connectedPeripherals[i]];
    }
    connectedPeripherals = [[NSMutableArray alloc]init];
    NSLog(@">>>babyBluetooth stop");
}
//停止扫描
-(void)stopScan{
    [bleManager stopScan];
}

#pragma mark -CBCentralManagerDelegate委托方法

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{

//    CBCentralManagerStateUnknown = 0,
//    CBCentralManagerStateResetting,
//    CBCentralManagerStateUnsupported,
//    CBCentralManagerStateUnauthorized,
//    CBCentralManagerStatePoweredOff,
//    CBCentralManagerStatePoweredOn,
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            break;
        default:
            break;
    }
    //状态改变callback
    if([currChannel blockOnCentralManagerDidUpdateState]){
        [currChannel blockOnCentralManagerDidUpdateState](central);
    }
}

//扫描到Peripherals
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //日志
    //NSLog(@"当扫描到设备:%@",peripheral.name);
   
    //设备添加到q列表
    [self addPeripheral:peripheral];
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didDiscoverPeripheral"
                                                       object:nil
                                                     userInfo:@{@"central":central,@"peripheral":peripheral,@"advertisementData":advertisementData,@"RSSI":RSSI}];

    
    //扫描到设备callback
    if([currChannel blockOnDiscoverPeripherals]){
        if ([currChannel filterOnDiscoverPeripherals](peripheral.name)) {
            [[babySpeaker callbackOnCurrChannel] blockOnDiscoverPeripherals](central,peripheral,advertisementData,RSSI);
        }
    }
    
    //处理连接设备
    if(needConnectPeripheral){
        if ([currChannel filterOnConnetToPeripherals](peripheral.name)) {
            [bleManager connectPeripheral:peripheral options:nil];
            //开一个定时器监控连接超时的情况
            connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(disconnect:) userInfo:peripheral repeats:NO];
        }
    }
}

//停止扫描
-(void)disconnect:(id)sender{
    [bleManager stopScan];
}

//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    [connectTimer invalidate];//停止时钟
    [connectedPeripherals addObject:peripheral];
    
    //执行回叫
    //扫描到设备callback
    if([currChannel blockOnConnectedPeripheral]){
        [currChannel blockOnConnectedPeripheral](central,peripheral);
    }
    
    //扫描外设的服务
    if (needDiscoverServices) {
        [peripheral setDelegate:self];
        [peripheral discoverServices:nil];
    }
    
}

//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
//    [self findPeripheral:peripheral.name]->failToConnectBlock(central,peripheral,error);
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    [connectedPeripherals removeObject:peripheral];
//    [self findPeripheral:peripheral.name]->disConnectBlock(central,peripheral,error);
}

//扫描到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{

//  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    //回叫block
    if ([currChannel blockOnDiscoverServices]) {
        [currChannel blockOnDiscoverServices](peripheral,error);
    }
    
    //discover characteristics
    if (needDiscoverCharacteristics) {
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}


//发现服务的Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    //回叫block
    if ([currChannel blockOnDiscoverCharacteristics]) {
        [currChannel blockOnDiscoverCharacteristics](peripheral,service,error);
    }
    
    //如果需要更新Characteristic的值
    if (needReadValueForCharacteristic) {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    //如果搜索Characteristic的Descriptors
    if (needDiscoverDescriptorsForCharacteristic) {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            [peripheral discoverDescriptorsForCharacteristic:characteristic];
        }
    }
}

//读取Characteristics的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{

    if (error)
    {
        NSLog(@"error didUpdateValueForCharacteristic %@ with error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    //查找字段订阅
    if([babySpeaker notifyCallback:characteristic]){
        [babySpeaker notifyCallback:characteristic](peripheral,characteristic,error);
        return;
    }
    //回叫block
    if ([currChannel blockOnReadValueForCharacteristic]) {
        [currChannel blockOnReadValueForCharacteristic](peripheral,characteristic,error);
    }
    
}
//发现Characteristics的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered DescriptorsForCharacteristic for %@ with error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    //回叫block
    if ([currChannel blockOnDiscoverDescriptorsForCharacteristic]) {
        [currChannel blockOnDiscoverDescriptorsForCharacteristic](peripheral,characteristic,error);
    }
    //如果需要更新Characteristic的Descriptors
    if (needReadValueForDescriptors) {
        for (CBDescriptor *d in characteristic.descriptors)
        {
            [peripheral readValueForDescriptor:d];
        }
    }
    
    //执行一次的方法
    if (oneReadValueForDescriptors) {
        for (CBDescriptor *d in characteristic.descriptors)
        {
            [peripheral readValueForDescriptor:d];
        }
        oneReadValueForDescriptors = NO;
    }
}

//读取Characteristics的Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{

    if (error)
    {
        NSLog(@"error didUpdateValueForDescriptor  for %@ with error: %@", descriptor.UUID, [error localizedDescription]);
        return;
    }
    //回叫block
    if ([currChannel blockOnReadValueForDescriptors]) {
        [currChannel blockOnReadValueForDescriptors](peripheral,descriptor,error);
    }

}


//characteristic.isNotifying 状态改变
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//        NSLog(@">>>didUpdateNotificationStateForCharacteristic");
//        NSLog(@">>>uuid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"isNotifying":@"Notifying");
}


-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(@">>>didWriteValueForCharacteristic");
//    NSLog(@">>>uuid:%@,new value:%@",characteristic.UUID,characteristic.value);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
//    NSLog(@">>>didWriteValueForCharacteristic");
//    NSLog(@">>>uuid:%@,new value:%@",descriptor.UUID,descriptor.value);
}

#pragma mark -私有方法

#pragma mark -设备list管理

-(void)addPeripheral:(CBPeripheral *)peripheral{
    if(![peripherals objectForKey:peripheral.name] && ![peripheral.name isEqualToString:@""] ){
        [peripherals setObject:peripheral forKey:peripheral.name];
    }
}

-(void)deletePeripheral:(NSString *)peripheralName{
    [peripherals removeObjectForKey:peripheralName];
}

-(CBPeripheral *)findPeripheral:(NSString *)peripheralName{
    return [peripherals objectForKey:peripheralName];
}

-(NSMutableDictionary *)findPeripherals{
    return peripherals;
}


@end
