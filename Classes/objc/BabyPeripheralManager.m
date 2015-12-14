//
//  BabyPeripheralManager.m
//  BluetoothStubOnIOS
//
//  Created by 刘彦玮 on 15/12/12.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import "BabyPeripheralManager.h"
#import "BabyToy.h"


@implementation BabyPeripheralManager{
    int PERIPHERAL_MANAGER_INIT_WAIT_TIMES;
    int didAddServices;
    NSTimer *addServiceTask;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _localName = @"";
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
    }
    return  self;    
    
}


-(BabyPeripheralManager *(^)())startAdvertising{
    return ^BabyPeripheralManager *(){
        
//        NSMutableArray *servicesUUIDforAD = [NSMutableArray array];

        
//        for (NSObject *item in servicesUUID) {
//            //如果servicesUUID内是UUID
//            if([servicesUUID firstObject] && [[servicesUUID firstObject] isKindOfClass:[NSUUID class]]){
//                [servicesUUIDforAD addObject:item];
//            }
//            //如果servicesUUID内是string
//            if([servicesUUID firstObject] && [[servicesUUID firstObject] isKindOfClass:[NSString class]]){
//                NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:(NSString *)item];
//                if (uuid) {  [servicesUUIDforAD addObject:item]; }
//            }
//        }

        if ([self canStartAdvertising]) {
            PERIPHERAL_MANAGER_INIT_WAIT_TIMES = 0;
            NSMutableArray *UUIDS = [NSMutableArray array];
            for (CBMutableService *s in _services) {
                [UUIDS addObject:s.UUID];
            }
            //启动广播
            [_peripheralManager startAdvertising:
             @{
               CBAdvertisementDataServiceUUIDsKey :  UUIDS
               ,CBAdvertisementDataLocalNameKey : _localName
             }];
        }else{
            PERIPHERAL_MANAGER_INIT_WAIT_TIMES++;
            if (PERIPHERAL_MANAGER_INIT_WAIT_TIMES > 5) {
                NSLog(@">>>error： 第%d次等待peripheralManager打开任然失败，请检查蓝牙设备是否可用",PERIPHERAL_MANAGER_INIT_WAIT_TIMES);
            }
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.startAdvertising();
            });
            NSLog(@">>> 第%d次等待peripheralManager打开",PERIPHERAL_MANAGER_INIT_WAIT_TIMES);
        }
        
        return self;
    };
}

-(BOOL)canStartAdvertising{
    if (_peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        return NO;
    }
    if (didAddServices != _services.count) {
        return NO;
    }
    return YES;
}

-(BOOL)isPoweredOn{
    if (_peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        return NO;
    }
    return YES;
}

-(BabyPeripheralManager *(^)(NSArray *array))addServices{
    return ^BabyPeripheralManager*(NSArray *array){
        _services = [NSMutableArray arrayWithArray:array];
        [self addServicesToPeripheral];
        return  self;
    };
}

-(void)addServicesToPeripheral{
    if ([self isPoweredOn]) {
        for (CBMutableService *s in _services) {
            [_peripheralManager addService:s];
        }
    }else{
        [addServiceTask setFireDate:[NSDate distantPast]];
        addServiceTask = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addServicesToPeripheral) userInfo:nil repeats:NO];
    }
}

-(BabyPeripheralManager *(^)(CBMutableService *server))addService{
    return ^BabyPeripheralManager*(CBMutableService *server){
        return  self;
    };
}



#pragma mark- peripheralManager delegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            NSLog(@">>>CBPeripheralManagerStateUnknown");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@">>>CBPeripheralManagerStateResetting");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@">>>CBPeripheralManagerStateUnsupported");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@">>>CBPeripheralManagerStateUnauthorized");
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@">>>CBPeripheralManagerStatePoweredOff");
            break;
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@">>>CBPeripheralManagerStatePoweredOn");
            //发送centralManagerDidUpdateState通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CBPeripheralManagerStatePoweredOn" object:nil];
            break;
        default:
            break;
    }
}


-(void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    didAddServices++;
    NSLog(@"didAddServices number:%d",didAddServices);
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic{
    
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests{
    
    
}

-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    
    
}

-(void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    
}

#warning 实现全部委托
#warning 优化等待流程


@end


/*
 *  paramter for properties
 *	r                       CBCharacteristicPropertyRead
 *	w                       CBCharacteristicPropertyWrite
 *	n                       CBCharacteristicPropertyNotify
 *  default value is rw     Read-Write
 
 *  paramter for permissions:
 *	r                       Read-only.
 *	w                       Write-only.
 *	R                       Readable by trusted devices.
 *	W                       Writeable by trusted devices.
 *  default value is rw     Read-Write
 */
void addCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *value,NSString *properties,NSString *permissions,NSString *descriptor)
{
    //paramter for value
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    //paramter for permissions
    CBCharacteristicProperties prop = 0x00;
    if([properties containsString:@"r"]){
        prop =  prop | CBCharacteristicPropertyRead;
    }
    if([properties containsString:@"w"]){
        prop =  prop | CBCharacteristicPropertyWrite;
    }
    if([properties containsString:@"n"]){
        prop =  prop | CBCharacteristicPropertyNotify;
    }
    if (properties == nil || [properties isEqualToString:@""]) {
        prop = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
    }
    
    //paramter for properties
    CBAttributePermissions perm = 0x00;
    if([permissions containsString:@"r"]){
        perm =  perm | CBAttributePermissionsReadable;
    }
    if([properties containsString:@"w"]){
        perm =  perm | CBAttributePermissionsWriteable;
    }
    if([permissions containsString:@"R"]){
        perm =  perm | CBAttributePermissionsReadEncryptionRequired;
    }
    if([properties containsString:@"W"]){
        perm =  perm | CBAttributePermissionsWriteEncryptionRequired;
    }
    if (permissions == nil || [permissions isEqualToString:@""]) {
        perm = CBAttributePermissionsReadable | CBAttributePermissionsWriteable;
    }
    
    
    CBMutableCharacteristic *c = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:UUID] properties:prop  value:nil permissions:perm];
    
    //paramter for descriptor
    if (!(descriptor == nil || [descriptor isEqualToString:@""]) ) {
        //c设置description对应的haracteristics字段描述
        CBUUID *CBUUIDCharacteristicUserDescriptionStringUUID = [CBUUID UUIDWithString:CBUUIDCharacteristicUserDescriptionString];
        CBMutableDescriptor *desc = [[CBMutableDescriptor alloc]initWithType: CBUUIDCharacteristicUserDescriptionStringUUID value:descriptor];
        [c setDescriptors:@[desc]];
    }
    
    if (!service.characteristics) {
        service.characteristics = @[];
    }
    NSMutableArray *cs = [service.characteristics mutableCopy];
    [cs addObject:c];
    service.characteristics = [cs copy];
}

CBMutableService* CBServiceMake(NSString *UUID)
{
    CBMutableService *s = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:UUID] primary:YES];
    return s;
}

