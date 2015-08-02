//
//  SimpleBLENotifiyHandler.m
//  PlantAssistant
//
//  Created by ZTELiuyw on 15/7/30.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "Babysister.h"

@implementation Babysister



-(instancetype)init{
    self = [super init];
    if(self){
        //pocket
        pocket = [[NSMutableDictionary alloc]init];
        
        //监听通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scanForPeripheralNotifyReceived:) name:@"scanForPeripherals" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didDiscoverPeripheralNotifyReceived:) name:@"didDiscoverPeripheral" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectToPeripheralNotifyReceived:) name:@"connectToPeripheral" object:nil];
        
    }
    return  self;
}




#pragma mark -委托方法

//开始扫描
-(void)scanForPeripheralNotifyReceived:(NSNotification *)notify{
    NSLog(@">>>scanForPeripheralsNotifyReceived");
}

//扫描到设备
-(void)didDiscoverPeripheralNotifyReceived:(NSNotification *)notify{
    CBPeripheral *peripheral =[notify.userInfo objectForKey:@"peripheral"];
    NSLog(@">>>didDiscoverPeripheralNotifyReceived:%@",peripheral.name);
}

//开始连接设备
-(void)connectToPeripheralNotifyReceived:(NSNotification *)notify{
    NSLog(@">>>connectToPeripheralNotifyReceived");
}

#pragma mark -委托方法

//连接设备成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    m_connectedPeripheralBlock = block;
}
//找到设备的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    m_discoverToPeripheralsBlock = block;
}

//设置查找服务回叫
-(void)setBlockOndDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    m_discoverServicesBlock = block;
}

//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    discoverPeripheralsFilter = filter;
}

//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    connePeripheralsFilter = filter;
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
}

//扫描到Peripherals
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //日志
//    NSLog(@"当扫描到设备:%@",peripheral.name);
   
    //设备添加到q列表
    [self addPeripheral:peripheral];
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didDiscoverPeripheral"
                                                       object:nil
                                                     userInfo:@{@"central":central,@"peripheral":peripheral,@"advertisementData":advertisementData,@"RSSI":RSSI}];
    //扫描到设备callback
    if(m_discoverToPeripheralsBlock){
        if (!discoverPeripheralsFilter) {
            //若为空，则所有都匹配名称不为空的设备
            discoverPeripheralsFilter =  ^(NSString *str){
                if(![str isEqualToString:@""])
                    return YES;
                return NO;
            };
        }
        if (discoverPeripheralsFilter(peripheral.name)) {
            m_discoverToPeripheralsBlock(central,peripheral,advertisementData,RSSI);
        }
    }
    
    //处理连接设备
    if(needConnectPeripheral){
         if (!connePeripheralsFilter) {
             connePeripheralsFilter =  ^(NSString *str){
                 if(![str isEqualToString:@""])
                     return YES;
                 return NO;
             };
         }
        if (connePeripheralsFilter(peripheral.name)) {
            //    //连接设备
//            [central connectPeripheral:peripheral->CBperipheral
//                                    options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
            [central connectPeripheral:peripheral options:nil];
        }
    }
    

}

//连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    [connectTimer invalidate];//停止时钟
    //执行回叫
    //扫描到设备callback
    if(m_discoverToPeripheralsBlock){
        if (!discoverPeripheralsFilter) {
            //若为空，则所有都匹配名称不为空的设备
            discoverPeripheralsFilter =  ^(NSString *str){
                if(![str isEqualToString:@""])
                    return YES;
                return NO;
            };
        }
        if (discoverPeripheralsFilter(peripheral.name)) {
            m_connectedPeripheralBlock(central,peripheral);
        }
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
//    [self findPeripheral:peripheral.name]->disConnectBlock(central,peripheral,error);
}

//扫描到服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{

//    NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error)
    {
        NSLog(@">>>Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    //回叫block
    if (needDiscoverServices) {
        m_discoverServicesBlock(peripheral,error);
    }
    //discover characteristics
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }

}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
         [peripheral readValueForCharacteristic:characteristic];

    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{


    NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if (value) {
        NSLog(@"%@>>>>>%@>>>>>%@",characteristic.service.UUID, characteristic.UUID,value);
    }else{
        NSLog(@"%@>>>>>%@>>>>>%@",characteristic.service.UUID, characteristic.UUID,characteristic.value);
    }
    if ([characteristic.UUID.UUIDString isEqualToString:@"2A23"]) {
      
    }
   

    
}

#pragma mark -私有方法

#pragma mark -设备list管理

-(void)addPeripheral:(CBPeripheral *)peripheral{
    BBPeripheral *sbPeripheral = [[BBPeripheral alloc]initWithSBPeripheral:peripheral];
    if(![peripherals objectForKey:peripheral.name] && ![peripheral.name isEqualToString:@""] ){
        [peripherals setObject:sbPeripheral forKey:peripheral.name];
    }
}

-(void)deletePeripheral:(NSString *)peripheralName{
    [peripherals removeObjectForKey:peripheralName];
}

-(BBPeripheral *)findPeripheral:(NSString *)peripheralName{
    return [peripherals objectForKey:peripheralName];
}

-(NSMutableDictionary *)findPeripherals{
    return peripherals;
}

#warning todo
#pragma mark -未测试的方法
//查找设备
//-(void) scanForPeripheralsWithBlock:(SBDiscoverToPeripheralsBlock)discoverBlock
//{
//
//    [self m_scanForPeripherals];
//    discoverPeripheralBlock = discoverBlock;
//    
//}





@end
