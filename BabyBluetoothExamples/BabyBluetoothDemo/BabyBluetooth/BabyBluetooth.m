//
//  GAAT.m
//  PlantAssistant
//
//  Created by 刘彦玮 on 15/3/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyBluetooth.h"


@interface CBPeripheral ()



@end



@implementation BabyBluetooth{
    Babysister *bleHander;
}



//单例模式
+(instancetype)shareSimpleBLE{
    static BabyBluetooth *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[BabyBluetooth alloc]init];
    });
    
    return share;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        //线程
        peripheralsSemaphore = dispatch_semaphore_create(0);
        simpleBleQueue = dispatch_queue_create("com.jumppo.simpleBLE", NULL);
        //初始化对象
        bleHander = [[Babysister alloc]init];
        bleManager = [[BBCentralManager alloc]initWithDelegate:bleHander queue:dispatch_get_main_queue()];

    }
    return self;

}

#pragma mark -委托方法

-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    bleHander->blockOnDiscoverPeripherals = block;
}


-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    bleHander->blockOnConnectedPeripheral = block;
}

//设置查找服务回叫
-(void)setBlockOndDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    bleHander->blockOnDiscoverServices = block;
}

//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    bleHander->filterOnDiscoverPeripherals = filter;
}

//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    bleHander->filterOnConnetToPeripherals = filter;
}



#pragma mark -链式函数
//查找Peripherals
-(BabyBluetooth *(^)()) scanForPeripherals{
    
    return ^BabyBluetooth *(){
         bleHander->needScanForPeripherals = YES;
        
        return self;
    };
}

//连接Peripherals
-(BabyBluetooth *(^)()) connectToPeripheral{
    return ^BabyBluetooth *(){
        bleHander->needConnectPeripheral = YES;
        return self;
    };
    
}

-(BabyBluetooth *(^)()) connectToPeripheral:(CBPeripheral *)peripheral{
    return ^BabyBluetooth *(){
        bleHander->needConnectPeripheral = YES;
        [bleHander->pocket setValue:peripheral forKey:@"peripheral"];
        return self;
    };
}

//发现Services
-(BabyBluetooth *(^)()) discoverServices{
    return ^BabyBluetooth *(){
         bleHander->needDiscoverServices = YES;
        return self;
    };
    
}

//获取Characteristics
-(BabyBluetooth *(^)()) discoverCharacteristics{
    return ^BabyBluetooth *(){
        bleHander->needDiscoverCharacteristics = YES;
        return self;
    };
    
}
//开始并执行
-(BabyBluetooth *(^)()) begin{
    [self validateProcess];
    return ^BabyBluetooth *(){
        //开始扫描peripherals
        if(bleHander->needScanForPeripherals){
            [bleManager scanForPeripherals];
        }
        //重置状态
        babyStatus = BabyStatusRuning;
        return self;
    };
   
    
}


//开始并执行sec秒后停止
-(BabyBluetooth *(^)()) begin:(int)sec{
    [self validateProcess];
    return ^BabyBluetooth *(int sec){
        //开始扫描peripherals
        if(bleHander->needScanForPeripherals){
            [bleManager scanForPeripherals];
        }
        //重置状态
        babyStatus = BabyStatusRuning;
        [self performSelector:@selector(stop) withObject:nil afterDelay:sec];
        return self;
    };
}

-(void)validateProcess{
    NSString *reason = @"";
    
    
    
    
    //需要扫描
    if (bleHander->needScanForPeripherals) {

            

        
    }
    //不需要扫描
    else{
        CBPeripheral *peripheral = [bleHander->pocket valueForKey:@"peripheral"];
        if (!peripheral) {
            reason = @"若不执行scanForPeripherals方法，则必须执行connectToPeripheral方法并且需要传入参数(CBPeripheral *)peripheral";
        }
    }
    
    
    
    
    
    NSException *e = [NSException exceptionWithName:@"BadyBluetooth process exception" reason:reason userInfo:nil];
    if (![reason isEqualToString:@""]) {
        @throw e;
    }
}
//停止
-(void(^)()) stop{
    return ^(){
        bleHander->needScanForPeripherals = NO;
        bleHander->needConnectPeripheral = NO;
        bleHander->needDiscoverServices = NO;
        bleHander->needDiscoverCharacteristics = NO;
        babyStatus = BabyStatusStop;
        //停止扫描，断开连接
        [bleManager stopScan];
        NSMutableArray *connectedPeripherals = [bleHander->pocket valueForKey:@"connectedPeripherals"];
        if (connectedPeripherals) {
            for (CBPeripheral *p in connectedPeripherals) {
                [bleManager cancelPeripheralConnection:p];
            }
        }
        [bleHander->pocket setObject:[NSNull null] forKey:@"connectedPeripherals"];
    };
}

-(BabyBluetooth *) and{
    NSLog(@"and");
    return self;
}
-(BabyBluetooth *) then{
    NSLog(@"then");
    return self;
}


#pragma mark - 查找设备



/**
 * 默认时间内（10秒）扫描出周围的设备
 * @return 扫描到的设备列表 NSMutableArray<CBPeripheral>
 */
//-(NSMutableArray *) scanForPeripherals{
//    NSMutableArray *devices = [[NSMutableArray alloc]init];
//    
//    [self scanPeripherals];
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:10];
//        [self stopScan:nil];
//    });
//    
//    [[self findPeripherals] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        SBPeripheral *SBperipheral = obj;
//        [devices addObject:SBperipheral->CBperipheral];
//    }];
//    
//    return devices;
//}

/**
 * 给定时间内扫描出周围的设备，
 * @warning 该方法是线程同步方法完成，须用异步方式调用，否则会造成线程柱塞
 * @see 相同功能的异步版本 scanForPeripheralsWithBlock:(SBDiscoverToPeripheralsBlock)discoverBlock
 * @param scanTime 给定的时间，单位为秒
 * @return 扫描到的设备列表 NSMutableArray<CBPeripheral>
 */
#warning todo
//-(NSMutableArray *)scanForPeripheralsInSecond:(int)scanTime{
//    
//    NSMutableArray *devices = [[NSMutableArray alloc]init];
//    
//   [self m_scanForPeripherals];
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:scanTime];
//        [self stopScan:nil];
//    });
//    
//    [[self findPeripherals] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        SBPeripheral *SBperipheral = obj;
//        [devices addObject:SBperipheral->CBperipheral];
//    }];
//    
//    return devices;
//}










//主设备状态更新
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}



#pragma mark - 连接设备
#warning todo
//连接设备
//-(void) connectToPeripheral:(NSString *)peripheralName succeedBlock:(SBConnectedBlock)succeedBlock failedBlock:(SBFailToConnectBlock)failedBlock disconnectBlock:(SBDisconnectBlock)disconnectBlock{
//    
//    SBPeripheral *peripheral = [self findPeripheral:peripheralName];
//    peripheral->connectedBlock = succeedBlock;
//    peripheral->failToConnectBlock = failedBlock;
//    peripheral->disConnectBlock = disconnectBlock;
//
//    //连接设备
//    [self.manager connectPeripheral:peripheral->CBperipheral
//                            options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
//    
//    //开一个定时器监控连接超时的情况
//    connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(disconnect:) userInfo:peripheral repeats:NO];
//    
//}

/**
 *  连接设备并扫描服务
 */
#warning todo
//-(void) connectToPeripheral:(NSString *)peripheralName
//               succeedBlock:(SBConnectedBlock)succeedBlock
//                failedBlock:(SBFailToConnectBlock)failedBlock
//            disconnectBlock:(SBDisconnectBlock)disconnectBlock
//           discoverServicesBlock:(SBDiscoverServicesBlock)discoverServicesBlock{
//    
//    [self connectToPeripheral:peripheralName succeedBlock:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        //发现服务
//        [peripheral setDelegate:self];
//        [peripheral discoverServices:nil];
//        //找到SBPeripheral ，设定找到服务的block
//        SBPeripheral *sbperipheral = [self findPeripheral:peripheralName];
//        sbperipheral->discoverServiceslock = discoverServicesBlock;
//        succeedBlock(central, peripheral);
//    }failedBlock:failedBlock disconnectBlock:disconnectBlock];
//     SBPeripheral *peripheral = [self findPeripheral:peripheralName];
//    peripheral->discoverServiceslock = discoverServicesBlock;
//    
//}

//断开设备连接
#warning todo
//-(void) disconnect:(CBPeripheral *)peripheral
//{
//    NSLog(@"disconnect：连接断开");
//    [self.manager cancelPeripheralConnection:peripheral];
//}
//




#pragma mark -外设服务
#warning todo
///**
// *  找到设备服务
// */
//-(void) scanServices:(CBPeripheral *)peripheral succeed:(SBDiscoverServicesBlock)succeed{
//    
//    
//}
//扫描外设服务
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
//{
//    NSLog(@"didDiscoverServices");
//    NSLog(@"%d",peripheral.state);
//    
//    if (error)
//    {
//        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
//        
//        return;
//    }
//    //回叫block
//    SBPeripheral *sbPeripheral = [self findPeripheral:peripheral.name];
//    if (sbPeripheral) {
//        sbPeripheral->discoverServiceslock(peripheral,error);
//    }
//
//    //discover characteristics
//    
//        
//}



//获取设备的characteristics
-(void) fetchPeripheralCharacteristics:(CBPeripheral *)peripheral{
    
    for (int i=0; i < peripheral.services.count; i++) {
      CBService *service = [peripheral.services objectAtIndex:i];
      NSLog(@"Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:service.UUID]);
      [peripheral discoverCharacteristics:nil forService:service];
    }
    
}


//获取指定服务的characteristics
-(void)fetchServicesCharacteristics:(CBPeripheral *)peripheral service:(CBService *)service{
    [peripheral discoverCharacteristics:nil forService:service];
}

//获取指定服务,指定名称的characteristics
-(void)fetchCharacteristicsByName:(NSArray *)characteristicsNames
                       peripheral:(CBPeripheral *)peripheral
                          service:(CBService *)service{

    [peripheral discoverCharacteristics:characteristicsNames forService:service];
}

//扫描服务到服务的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
   
    
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
   // [self testwriteChar:peripheral characteristic:[service.characteristics objectAtIndex:5]];
    
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        
//        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:(__bridge CFUUIDRef )peripheral.identifier]);
        
        //[self readValue:service.UUID characteristicUUID:characteristic.UUID p:peripheral];
        [_testPeripheral readValueForCharacteristic:characteristic];
        
        
        //开启长连接
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"39E1FA06-84A8-11E2-AFBA-0002A5D5C51B"]] ) {
            int i = 1;
            NSData *data = [NSData dataWithBytes: &i length: 1];
            [_testPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            
        
        }
        
        
        
        //订阅通知
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"39E1FA05-84A8-11E2-AFBA-0002A5D5C51B"]] ) {
            [_testPeripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
    }
    
    
}

//////////////////////////////////////////////end特征和外设////////////////////////////////////////////////


//////////////////////////////////////////////数据交互////////////////////////////////////////////////
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    NSLog(@"================================================");
    NSLog(@"properties:%lu for descriptors: %@ value: %@", characteristic.properties, characteristic.descriptors, characteristic.value);
    NSLog(@"characteristic UUID:%@ and service uuid : %@", characteristic.UUID
             ,characteristic.service.UUID);
    NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"%@",value);
    
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    debugMethod();s
}
-(void)testwriteChar:(CBPeripheral *)peripheral characteristic: (CBCharacteristic *)characteristic
{
    int i = 1;
    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//     debugMethod();
}

/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 */

-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    printf("In read Value");
    
    int suuid = 0xFFF0;
    int cuuid = 0xFFF4;
    UInt16 s = [self swap:suuid];
    UInt16 c = [self swap:cuuid];
    
    
    //    UInt16 s = [self swap:serviceUUID];
    //    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:(__bridge CFUUIDRef )p.identifier]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}

 


//////////////////////////////////////////////工具方法////////////////////////////////////////////////

/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 *
 */
-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


/*
 *  @method UUIDToString
 *
 *  @param UUID UUID to convert to string
 *
 *  @returns Pointer to a character buffer containing UUID in string representation
 *
 *  @discussion UUIDToString converts the data of a CFUUIDRef class to a character pointer for easy printout using printf()
 *
 */
-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *
 *  @discussion swap byteswaps a UInt16
 *
 *  @return Byteswapped UInt16
 */

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a
 *  service with a specific UUID
 *
 */
-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p {
    
    NSLog(@"----------services = %@",p.services);
    
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        NSLog(@"----------s = %@",s);
        
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service
 *  to find a characteristic with a specific UUID
 *
 */
-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 *
 */

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}





#pragma mark -test



-(int (^)(int, int))add{
    return ^int(int a,int b){
        return a+b;
    };
}
//- (MASConstraint * (^)(id))equalTo {
//    return ^id(id attribute) {
//        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
//    };
//}

@end
