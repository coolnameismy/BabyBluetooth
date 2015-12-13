//
//  BabyPeripheralManager.m
//  BluetoothStubOnIOS
//
//  Created by 刘彦玮 on 15/12/12.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import "BabyPeripheralManager.h"


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


@end


void addCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *value,NSString *descriptors,NSString *permissions,NSString *descriptor)
{
    CBMutableCharacteristic *c = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:UUID] properties:CBCharacteristicPropertyRead  value:nil permissions:CBAttributePermissionsReadable];
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

