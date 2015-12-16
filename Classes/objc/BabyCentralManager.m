/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/7/30.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyCentralManager.h"
#import "BabyCallback.h"

@implementation BabyCentralManager

#define currChannel [babySpeaker callbackOnCurrChannel]


-(instancetype)init{
    self = [super init];
    if(self){
        
        
#if  __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_0
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //蓝牙power没打开时alert提示框
                                 [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                                 //重设centralManager恢复的IdentifierKey
                                 @"babyBluetoothRestore",CBCentralManagerOptionRestoreIdentifierKey,
                                 nil];

#else
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //蓝牙power没打开时alert提示框
                                 [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                                 nil];
#endif
        
        NSArray *backgroundModes = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"UIBackgroundModes"];
        if ([backgroundModes containsObject:@"bluetooth-central"]) {
           //后台模式
           centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:options];
        }else{
           //非后台模式
           centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        }
        
        //pocket
        pocket = [[NSMutableDictionary alloc]init];
        connectedPeripherals = [[NSMutableArray alloc]init];
       
        
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
    [centralManager scanForPeripheralsWithServices:[currChannel babyOptions].scanForPeripheralsWithServices options:[currChannel babyOptions].scanForPeripheralsWithOptions];
}
//连接Peripherals
-(void)connectToPeripheral:(CBPeripheral *)peripheral{
    [centralManager connectPeripheral:peripheral options:[currChannel babyOptions].connectPeripheralWithOptions];
}


//断开设备连接
-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral{
    [centralManager cancelPeripheralConnection:peripheral];
}

//断开所有已连接的设备
-(void)cancelAllPeripheralsConnection{
    for (int i=0;i<connectedPeripherals.count;i++) {
        [centralManager cancelPeripheralConnection:connectedPeripherals[i]];
    }
}
//停止扫描
-(void)cancelScan{
    [centralManager stopScan];
    //停止扫描callback
    if([currChannel blockOnCancelScan]){
        [currChannel blockOnCancelScan](centralManager);
    }

}

#pragma mark -CBCentralManagerDelegate委托方法

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
 
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
            //发送centralManagerDidUpdateState通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CBCentralManagerStatePoweredOn" object:nil];
            break;
        default:
            break;
    }
    //状态改变callback
    if([currChannel blockOnCentralManagerDidUpdateState]){
        [currChannel blockOnCentralManagerDidUpdateState](central);
    }
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict{

}

//扫描到Peripherals
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    
    //日志
    //NSLog(@"当扫描到设备:%@",peripheral.name);
    
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
            [centralManager connectPeripheral:peripheral options:[currChannel babyOptions].connectPeripheralWithOptions];
            //开一个定时器监控连接超时的情况
            connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(disconnect:) userInfo:peripheral repeats:NO];
        }
    }
}

//停止扫描
-(void)disconnect:(id)sender{
    [centralManager stopScan];
}

//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    //设置委托
    [peripheral setDelegate:self];
    
    //NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    [connectTimer invalidate];//停止时钟
    [self addPeripheral:peripheral];
    
    //执行回叫
    //扫描到设备callback
    if([currChannel blockOnConnectedPeripheral]){
        [currChannel blockOnConnectedPeripheral](central,peripheral);
    }
    
    //扫描外设的服务
    if (needDiscoverServices) {
        [peripheral discoverServices:[currChannel babyOptions].discoverWithServices];
        //discoverIncludedServices
    }
    
}

//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
    if ([currChannel blockOnFailToConnect]) {
        [currChannel blockOnFailToConnect](central,peripheral,error);
    }
}

//Peripherals断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
//    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    if (error)
    {
        NSLog(@">>> didDisconnectPeripheral for %@ with error: %@", peripheral.name, [error localizedDescription]);
    }
    
    [self deletePeripheral:peripheral];
    if ([currChannel blockOnDisconnect]) {
        [currChannel blockOnDisconnect](central,peripheral,error);
    }
    
    //判断是否全部链接都已经段开
    if ([self findConnectedPeripherals].count == 0) {
        //停止扫描callback
        if([currChannel blockOnCancelAllPeripheralsConnection]){
            [currChannel blockOnCancelAllPeripheralsConnection](centralManager);
        }
        //    NSLog(@">>> stopConnectAllPerihperals");
    }
}

//扫描到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    
//  NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>didDiscoverServices for %@ with error: %@", peripheral.name, [error localizedDescription]);
//        return;
    }
    //回叫block
    if ([currChannel blockOnDiscoverServices]) {
        [currChannel blockOnDiscoverServices](peripheral,error);
    }
    
    //discover characteristics
    if (needDiscoverCharacteristics) {
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:[currChannel babyOptions].discoverWithCharacteristics forService:service];
        }
    }
}


//发现服务的Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error)
    {
        NSLog(@"error didDiscoverCharacteristicsForService for %@ with error: %@", service.UUID, [error localizedDescription]);
//        return;
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
//        return;
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
//        return;
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
//        return;
    }
    //回叫block
    if ([currChannel blockOnReadValueForDescriptors]) {
        [currChannel blockOnReadValueForDescriptors](peripheral,descriptor,error);
    }

}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    NSLog(@">>>didWriteValueForCharacteristic");
//    NSLog(@">>>uuid:%@,new value:%@",characteristic.UUID,characteristic.value);
    if ([currChannel blockOnDidWriteValueForCharacteristic]) {
        [currChannel blockOnDidWriteValueForCharacteristic](characteristic,error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
//    NSLog(@">>>didWriteValueForCharacteristic");
//    NSLog(@">>>uuid:%@,new value:%@",descriptor.UUID,descriptor.value);
    if ([currChannel blockOnDidWriteValueForDescriptor]) {
        [currChannel blockOnDidWriteValueForDescriptor](descriptor,error);
    }
}

//characteristic.isNotifying 状态改变
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@">>>didUpdateNotificationStateForCharacteristic");
    NSLog(@">>>uuid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"isNotifying":@"Notifying");
    if ([currChannel blockOnDidUpdateNotificationStateForCharacteristic]) {
        [currChannel blockOnDidUpdateNotificationStateForCharacteristic](characteristic,error);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error{
    if ([currChannel blockOnDidDiscoverIncludedServicesForService]) {
        [currChannel blockOnDidDiscoverIncludedServicesForService](service,error);
    }
}

//-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
//    NSLog(@"peripheralDidUpdateRSSI -> RSSI:%@",RSSI);
//    if ([currChannel blockOnDidReadRSSI]) {
//        [currChannel blockOnDidReadRSSI](RSSI,error);
//    }
//}



//- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
//    NSLog(@"peripheralDidUpdateRSSI -> RSSI:%@",peripheral.RSSI);
//        if ([currChannel blockOnDidReadRSSI]) {
//            [currChannel blockOnDidReadRSSI](peripheral.RSSI,error);
//        }
//}

#if  __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@">>>peripheralDidUpdateRSSI -> RSSI:%@",peripheral.RSSI);
    if ([currChannel blockOnDidReadRSSI]) {
        [currChannel blockOnDidReadRSSI](peripheral.RSSI,error);
    }
}
#else
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    NSLog(@">>>peripheralDidUpdateRSSI -> RSSI:%@",RSSI);
    if ([currChannel blockOnDidReadRSSI]) {
        [currChannel blockOnDidReadRSSI](RSSI,error);
    }
}
#endif

-(void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    if ([currChannel blockOnDidUpdateName]) {
        [currChannel blockOnDidUpdateName](peripheral);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices{
    if ([currChannel blockOnDidModifyServices]) {
        [currChannel blockOnDidModifyServices](peripheral,invalidatedServices);
    }
}




#pragma mark -私有方法

#pragma mark -设备list管理

-(void)addPeripheral:(CBPeripheral *)peripheral{
   if (![connectedPeripherals containsObject:peripheral]) {
       [connectedPeripherals addObject:peripheral];
    }
}

-(void)deletePeripheral:(CBPeripheral *)peripheral{
    [connectedPeripherals removeObject:peripheral];
}

-(CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName{
    for (CBPeripheral *p in connectedPeripherals) {
        if (p.name == peripheralName) {
            return p;
        }
    }
    return nil;
}

-(NSArray *)findConnectedPeripherals{
    return connectedPeripherals;
}


@end
