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
+(instancetype)shareBabyBluetooth{
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
        babySpeaker = [[BabySpeaker alloc]init];
        babysister->babySpeaker = babySpeaker;
        
    }
    return self;
    
}

#pragma mark -委托方法

//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[babySpeaker callback]setBlockOnDiscoverPeripherals:block];
}

//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    [[babySpeaker callback]setBlockOnConnectedPeripheral:block];
}

//设置查找服务回叫
-(void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callback]setBlockOnDiscoverServices:block];
}

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block{
    [[babySpeaker callback]setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block{
    [[babySpeaker callback]setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block{
    [[babySpeaker callback]setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block{
    [[babySpeaker callback]setBlockOnReadValueForDescriptors:block];
}


//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    [[babySpeaker callback]setFilterOnDiscoverPeripherals:filter];
}

//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter{
    [[babySpeaker callback]setFilterOnConnetToPeripherals:filter];
}


//channel
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripheralsOnChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverPeripherals:block];
}

//连接Peripherals成功的委托
-(void)setBlockOnConnectedOnChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnConnectedPeripheral:block];
}

//设置查找服务回叫
-(void)setBlockOnDiscoverServicesOnChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverServices:block];
}

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristicsOnChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristicOnChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristicOnChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptorsOnChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForDescriptors:block];
}


//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilterOnChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralsFilter))filter{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnDiscoverPeripherals:filter];
}

//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilterOnChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralsFilter))filter{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnConnetToPeripherals:filter];
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
    
        //调整委托方法的channel，如果没设置默认为缺省频道
        NSString *channel = [babysister->pocket valueForKey:@"channel"];
        [babySpeaker switchChannel:channel];
        
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
-(BabyBluetooth *(^)(int sec)) stop {
    
    return ^BabyBluetooth *(int sec){
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
        return self;
    };
    
}

//切换委托频道
-(BabyBluetooth *(^)(NSString *channel)) channel{
    return ^BabyBluetooth *(NSString *channel){
        //先缓存数据，到begin方法统一处理
        [babysister->pocket setValue:channel forKey:@"channel"];
        return self;
    };
}


#warning 未完成方法校验
-(void)validateProcess{
    
    NSMutableArray *faildReason = [[NSMutableArray alloc]init];
    
    //规则：不执行discoverDescriptorsForCharacteristic()时，不能执行readValueForDescriptors()
    if (!babysister->needDiscoverDescriptorsForCharacteristic) {
        if (!babysister->needReadValueForDescriptors) {
            [faildReason addObject:@"未执行discoverDescriptorsForCharacteristic()不能执行readValueForDescriptors()"];
        }
    }
    
    //规则：不执行discoverCharacteristics()时，不能执行readValueForCharacteristic()或者是discoverDescriptorsForCharacteristic()
    if (!babysister->needDiscoverCharacteristics) {
        if (babysister->needReadValueForCharacteristic||babysister->needDiscoverDescriptorsForCharacteristic) {
            [faildReason addObject:@"未执行discoverCharacteristics()不能执行readValueForCharacteristic()或discoverDescriptorsForCharacteristic()"];
        }
    }
    
    //规则： 不执行discoverServices()不能执行discoverCharacteristics()、readValueForCharacteristic()、discoverDescriptorsForCharacteristic()、readValueForDescriptors()
    if (!babysister->needDiscoverServices) {
        if (babysister->needDiscoverCharacteristics||babysister->needDiscoverDescriptorsForCharacteristic ||babysister->needReadValueForCharacteristic ||babysister->needReadValueForDescriptors) {
             [faildReason addObject:@"未执行discoverServices()不能执行discoverCharacteristics()、readValueForCharacteristic()、discoverDescriptorsForCharacteristic()、readValueForDescriptors()"];
        }
        
    }

    //规则：不执行connectToPeripherals()时，不能执行discoverServices()
    if(!babysister->needConnectPeripheral){
        if (babysister->needDiscoverServices) {
             [faildReason addObject:@"未执行connectToPeripherals()不能执行discoverServices()"];
        }
    }
    
    //规则：不执行needScanForPeripherals，必须执行connectToPeripheral()方法时带入参数peripheral
    if (!babysister->needScanForPeripherals) {
        CBPeripheral *peripheral = [babysister->pocket valueForKey:@"peripheral"];
        if (!peripheral) {
            [faildReason addObject:@"若不执行scanForPeripherals()方法，则必须执行connectToPeripheral方法并且需要传入参数(CBPeripheral *)peripheral"];
        }
    }
    
    //抛出异常
    NSException *e = [NSException exceptionWithName:@"BadyBluetooth usage exception" reason:[faildReason lastObject]  userInfo:nil];
    @throw e;
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




#pragma mark -test




@end


