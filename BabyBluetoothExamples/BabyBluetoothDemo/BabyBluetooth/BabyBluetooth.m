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
    Babysister *babysister;
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
        
        //初始化对象
        babysister = [[Babysister alloc]init];
      

    }
    return self;

}

#pragma mark -委托方法

//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    babysister->blockOnDiscoverPeripherals = block;
}

//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    babysister->blockOnConnectedPeripheral = block;
}

//设置查找服务回叫
-(void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    babysister->blockOnDiscoverServices = block;
}

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block{
    babysister->blockOnDiscoverCharacteristics = block;
}
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block{
    babysister->blockOnReadValueForCharacteristic = block;
}
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block{
    babysister->blockOnDiscoverDescriptorsForCharacteristic = block;
}
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block{
    babysister->blockOnReadValueForDescriptors = block;
}


//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    babysister->filterOnDiscoverPeripherals = filter;
}

//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    babysister->filterOnConnetToPeripherals = filter;
}



#pragma mark -链式函数
//查找Peripherals
-(BabyBluetooth *(^)()) scanForPeripherals{
    
    return ^BabyBluetooth *(){
         babysister->needScanForPeripherals = YES;
        
        return self;
    };
}

//连接Peripherals
-(BabyBluetooth *(^)()) connectToPeripherals{
    return ^BabyBluetooth *(){
        babysister->needConnectPeripheral = YES;
        return self;
    };
    
}

-(BabyBluetooth *(^)(CBPeripheral *peripheral)) connectToPeripheral{
    return ^BabyBluetooth *(CBPeripheral *peripheral){
        babysister->needConnectPeripheral = YES;
        [babysister->pocket setValue:peripheral forKey:@"peripheral"];
        return self;
    };
}

//发现Services
-(BabyBluetooth *(^)()) discoverServices{
    return ^BabyBluetooth *(){
         babysister->needDiscoverServices = YES;
        return self;
    };
    
}

//获取Characteristics
-(BabyBluetooth *(^)()) discoverCharacteristics{
    return ^BabyBluetooth *(){
        babysister->needDiscoverCharacteristics = YES;
        return self;
    };
    
}

//更新Characteristics的值
-(BabyBluetooth *(^)()) readValueForCharacteristic{
    return ^BabyBluetooth *(){
        babysister->needReadValueForCharacteristic = YES;
        return self;
    };
}

//设置查找到Descriptors名称的block
-(BabyBluetooth *(^)()) discoverDescriptorsForCharacteristic{
    return ^BabyBluetooth *(){
        babysister->needDiscoverDescriptorsForCharacteristic = YES;
        return self;
    };
    
}
//设置读取到Descriptors值的block
-(BabyBluetooth *(^)()) readValueForDescriptors{
    return ^BabyBluetooth *(){
        babysister->needReadValueForDescriptors = YES;
        return self;
    };
}

//开始并执行
-(BabyBluetooth *(^)()) begin{
    [self validateProcess];
    return ^BabyBluetooth *(){
        //直接连接或者是扫描后连接
        if (babysister->needScanForPeripherals) {
            //开始扫描peripherals
            if(babysister->needScanForPeripherals){
                [babysister scanPeripherals];
            }
        }else{
            CBPeripheral *p = [babysister->pocket valueForKey:@"peripheral"];
            if (p) {
                //直接连接设备
                [babysister connectToPeripheral:p];
            }
            
        }
        //重置状态
        babyStatus = BabyStatusRuning;
        return self;
    };
   
    
}

//sec秒后停止
-(void(^)(int sec)) stop {

    return ^(int sec){
        NSLog(@"stop in %d sec",sec);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            babysister->needScanForPeripherals = NO;
            babysister->needConnectPeripheral = NO;
            babysister->needDiscoverServices = NO;
            babysister->needDiscoverCharacteristics = NO;
            babysister->needReadValueForCharacteristic = NO;
            babysister->needDiscoverDescriptorsForCharacteristic = NO;
            babysister->needReadValueForDescriptors = NO;
            babyStatus = BabyStatusStop;
            babysister->pocket = [[NSMutableDictionary alloc]init];
            //停止扫描，断开连接
            [babysister stopScan];
            [babysister stopConnectAllPerihperals];            
        });
    };

} 

-(void)validateProcess{
    NSString *reason = @"";
    
    
    
    
    //需要扫描
    if (babysister->needScanForPeripherals) {

            

        
    }
    //不需要扫描
    else{
        CBPeripheral *peripheral = [babysister->pocket valueForKey:@"peripheral"];
        if (!peripheral) {
            reason = @"若不执行scanForPeripherals方法，则必须执行connectToPeripheral方法并且需要传入参数(CBPeripheral *)peripheral";
        }
    }
    
    NSException *e = [NSException exceptionWithName:@"BadyBluetooth process exception" reason:reason userInfo:nil];
    if (![reason isEqualToString:@""]) {
        @throw e;
    }
}


-(BabyBluetooth *) and{
    NSLog(@"and");
    return self;
}
-(BabyBluetooth *) then{
    NSLog(@"then");
    return self;
}





//读取Characteristic的详细信息
-(BabyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) fetchCharacteristicDetails{

    return ^(CBPeripheral *peripheral,CBCharacteristic *characteristic){
        //判断连接状态
        if (peripheral.state ==CBPeripheralStateConnected) {
            self->babysister->needReadValueForDescriptors = YES;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral discoverDescriptorsForCharacteristic:characteristic];

        }else{
            NSLog(@"!!!设备当前处于非连接状态");
        }
        
        return self;
    };
}
//-(BabyBluetooth *(^)())CharacteristicInfo:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic{
//
//    [peripheral readValueForCharacteristic:characteristic];
//    return ^(){
//        return self;
//    };
//}
//













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


 

@end


