/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/3/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.


#import "BabyBluetooth.h"



@implementation BabyBluetooth{
    Babysister *babysister;
    BabySpeaker *babySpeaker;
    int CENTRAL_MANAGER_INIT_WAIT_TIMES;
    NSTimer *timerForStop;
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

#pragma mark -babybluetooth的委托
/*
 默认频道的委托
 */
//设备状态改变的委托
-(void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block{
    [[babySpeaker callback]setBlockOnCentralManagerDidUpdateState:block];
}
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[babySpeaker callback]setBlockOnDiscoverPeripherals:block];
}
//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    [[babySpeaker callback]setBlockOnConnectedPeripheral:block];
}
//连接Peripherals失败的委托
-(void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callback]setBlockOnFailToConnect:block];
}
//断开Peripherals的连接
-(void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callback]setBlockOnDisconnect:block];
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
//设置蓝牙使用的参数参数
-(void)setBabyOptionsWithScanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
                          connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
                        scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                                  discoverWithServices:(NSArray *)discoverWithServices
                           discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics{
    BabyOptions *option = [[BabyOptions alloc]initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectPeripheralWithOptions scanForPeripheralsWithServices:scanForPeripheralsWithServices discoverWithServices:discoverWithServices discoverWithCharacteristics:discoverWithCharacteristics];
    [[babySpeaker callback]setBabyOptions:option];
}

/*
 channel的委托
 */
//设备状态改变的委托
-(void)setBlockOnCentralManagerDidUpdateStateAtChannel:(NSString *)channel
                                                 block:(void (^)(CBCentralManager *central))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCentralManagerDidUpdateState:block];
}
//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripheralsAtChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverPeripherals:block];
}

//连接Peripherals成功的委托
-(void)setBlockOnConnectedAtChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnConnectedPeripheral:block];
}

//连接Peripherals失败的委托
-(void)setBlockOnFailToConnectAtChannel:(NSString *)channel
                                  block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnFailToConnect:block];
}

//断开Peripherals的连接
-(void)setBlockOnDisconnectAtChannel:(NSString *)channel
                               block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDisconnect:block];
}

//设置查找服务回叫
-(void)setBlockOnDiscoverServicesAtChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverServices:block];
}

//设置查找到Characteristics的block
-(void)setBlockOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
-(void)setBlockOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
-(void)setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
-(void)setBlockOnReadValueForDescriptorsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForDescriptors:block];
}

//设置蓝牙运行时的参数
-(void)setBabyOptionsAtChannel:(NSString *)channel
 scanForPeripheralsWithOptions:(NSDictionary *) scanForPeripheralsWithOptions
  connectPeripheralWithOptions:(NSDictionary *) connectPeripheralWithOptions
    scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
          discoverWithServices:(NSArray *)discoverWithServices
   discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics{
    
    BabyOptions *option = [[BabyOptions alloc]initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectPeripheralWithOptions scanForPeripheralsWithServices:scanForPeripheralsWithServices discoverWithServices:discoverWithServices discoverWithCharacteristics:discoverWithCharacteristics];
     [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES]setBabyOptions:option];
}

#pragma mark -babybluetooth filter委托
//设置查找Peripherals的规则
-(void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName))filter{
    [[babySpeaker callback]setFilterOnDiscoverPeripherals:filter];
}
//设置连接Peripherals的规则
-(void)setFilterOnConnetToPeripherals:(BOOL (^)(NSString *peripheralName))filter{
    [[babySpeaker callback]setFilterOnConnetToPeripherals:filter];
}
//设置查找Peripherals的规则
-(void)setFilterOnDiscoverPeripheralsAtChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName))filter{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnDiscoverPeripherals:filter];
}
//设置连接Peripherals的规则
-(void)setFilterOnConnetToPeripheralsAtChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName))filter{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnConnetToPeripherals:filter];
}

#pragma mark -babybluetooth Special
//babyBluettooth cancelScan方法调用后的回调
-(void)setBlockOnCancelScanBlock:(void(^)(CBCentralManager *centralManager))block{
    [[babySpeaker callback]setBlockOnCancelScan:block];
}
//babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
-(void)setBlockOnCancelAllPeripheralsConnectionBlock:(void(^)(CBCentralManager *centralManager))block{
    [[babySpeaker callback]setBlockOnCancelAllPeripheralsConnection:block];
}
//babyBluettooth cancelPeripheralConnection 方法调用后的回调
-(void)setBlockOnCancelPeripheralConnectionBlock:(void(^)(CBCentralManager *centralManager,CBPeripheral *peripheral))block{
    [[babySpeaker callback]setBlockOnCancelPeripheralConnection:block];
}
//babyBluettooth cancelScan方法调用后的回调
-(void)setBlockOnCancelScanBlockAtChannel:(NSString *)channel
                                    block:(void(^)(CBCentralManager *centralManager))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelScan:block];
}
//babyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
-(void)setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:(NSString *)channel
                                                        block:(void(^)(CBCentralManager *centralManager))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelAllPeripheralsConnection:block];
}
//babyBluettooth cancelPeripheralConnection 方法调用后的回调
-(void)setBlockOnCancelPeripheralConnectionBlockAtChannel:(NSString *)channel
                                                    block:(void(^)(CBCentralManager *centralManager,CBPeripheral *peripheral))block{
    [[babySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelPeripheralConnection:block];
    
}

#pragma mark -链式函数
//查找Peripherals
-(BabyBluetooth *(^)()) scanForPeripherals{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needScanForPeripherals"];
        return self;
    };
}

//连接Peripherals
-(BabyBluetooth *(^)()) connectToPeripherals{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needConnectPeripheral"];
        return self;
    };
}

//发现Services
-(BabyBluetooth *(^)()) discoverServices{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needDiscoverServices"];
        return self;
    };
}

//获取Characteristics
-(BabyBluetooth *(^)()) discoverCharacteristics{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needDiscoverCharacteristics"];
        return self;
    };
}
//更新Characteristics的值
-(BabyBluetooth *(^)()) readValueForCharacteristic{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needReadValueForCharacteristic"];
        return self;
    };
}
//设置查找到Descriptors名称的block
-(BabyBluetooth *(^)()) discoverDescriptorsForCharacteristic{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needDiscoverDescriptorsForCharacteristic"];
        return self;
    };
}
//设置读取到Descriptors值的block
-(BabyBluetooth *(^)()) readValueForDescriptors{
    return ^BabyBluetooth *(){
        [babysister->pocket setObject:@"YES" forKey:@"needDiscoverDescriptorsForCharacteristic"];
        return self;
    };
}
//开始并执行
-(BabyBluetooth *(^)()) begin{
    return ^BabyBluetooth *(){
        //取消未执行的stop定时任务
        [timerForStop invalidate];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self resetSeriseParmeter];
            //处理链式函数缓存的数据
            if ([[babysister->pocket valueForKey:@"needScanForPeripherals"] isEqualToString:@"YES"]) {
                babysister->needScanForPeripherals = YES;
            }
            if ([[babysister->pocket valueForKey:@"needConnectPeripheral"] isEqualToString:@"YES"]) {
                babysister->needConnectPeripheral = YES;
            }
            if ([[babysister->pocket valueForKey:@"needDiscoverServices"] isEqualToString:@"YES"]) {
                babysister->needDiscoverServices = YES;
            }
            if ([[babysister->pocket valueForKey:@"needDiscoverCharacteristics"] isEqualToString:@"YES"]) {
                babysister->needDiscoverCharacteristics = YES;
            }
            if ([[babysister->pocket valueForKey:@"needReadValueForCharacteristic"] isEqualToString:@"YES"]) {
                babysister->needReadValueForCharacteristic = YES;
            }
            if ([[babysister->pocket valueForKey:@"needDiscoverDescriptorsForCharacteristic"] isEqualToString:@"YES"]) {
                babysister->needDiscoverDescriptorsForCharacteristic = YES;
            }
            if ([[babysister->pocket valueForKey:@"needReadValueForDescriptors"] isEqualToString:@"YES"]) {
                babysister->needReadValueForDescriptors = YES;
            }
            //调整委托方法的channel，如果没设置默认为缺省频道
            NSString *channel = [babysister->pocket valueForKey:@"channel"];
            [babySpeaker switchChannel:channel];
            //缓存的peripheral
            CBPeripheral *cachedPeripheral = [babysister->pocket valueForKey:NSStringFromClass([CBPeripheral class])];
            //校验series合法性
            [self validateProcess];
            //清空pocjet
            babysister->pocket = [[NSMutableDictionary alloc]init];
            //开始扫描或连接设备
            [self start:cachedPeripheral];
        });
        return self;
    };
}


//私有方法，扫描或连接设备
-(void)start:(CBPeripheral *)cachedPeripheral{
    if (babysister->bleManager.state == CBCentralManagerStatePoweredOn) {
        CENTRAL_MANAGER_INIT_WAIT_TIMES = 0;
        //扫描后连接
        if (babysister->needScanForPeripherals) {
            //开始扫描peripherals
            if(babysister->needScanForPeripherals){
                [babysister scanPeripherals];
            }
        }
        //直接连接
        else{
            if (cachedPeripheral) {
                [babysister connectToPeripheral:cachedPeripheral];
            }
        }
        return;
    }
    //尝试重新等待CBCentralManager打开
    CENTRAL_MANAGER_INIT_WAIT_TIMES ++;
    if (CENTRAL_MANAGER_INIT_WAIT_TIMES >=5 ) {
        NSLog(@">>> 第%d次等待CBCentralManager 打开任然失败，请检查你蓝牙使用权限或检查设备问题。",CENTRAL_MANAGER_INIT_WAIT_TIMES);
        return;
        //[NSException raise:@"CBCentralManager打开异常" format:@"尝试等待打开CBCentralManager5次，但任未能打开"];
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self start:cachedPeripheral];
    });
    NSLog(@">>> 第%d次等待CBCentralManager打开",CENTRAL_MANAGER_INIT_WAIT_TIMES);
}

//sec秒后停止
-(BabyBluetooth *(^)(int sec)) stop {
    
    return ^BabyBluetooth *(int sec){
        NSLog(@">>> stop in %d sec",sec);
        
        //听见定时器执行babyStop
        timerForStop = [NSTimer timerWithTimeInterval:sec target:self selector:@selector(babyStop) userInfo:nil repeats:NO];
        [timerForStop setFireDate: [[NSDate date]dateByAddingTimeInterval:sec]];
        [[NSRunLoop currentRunLoop] addTimer:timerForStop forMode:NSRunLoopCommonModes];
        
        return self;
    };
}

//私有方法，停止扫描和断开连接，清空pocket
-(void)babyStop{
    NSLog(@">>>did stop");
    [timerForStop invalidate];
    [self resetSeriseParmeter];
    babysister->pocket = [[NSMutableDictionary alloc]init];
    //停止扫描，断开连接
    [babysister cancelScan];
    [babysister cancelAllPeripheralsConnection];
}

//重置串行方法参数
-(void)resetSeriseParmeter{
    babysister->needScanForPeripherals = NO;
    babysister->needConnectPeripheral = NO;
    babysister->needDiscoverServices = NO;
    babysister->needDiscoverCharacteristics = NO;
    babysister->needReadValueForCharacteristic = NO;
    babysister->needDiscoverDescriptorsForCharacteristic = NO;
    babysister->needReadValueForDescriptors = NO;
}

//持有对象
-(BabyBluetooth *(^)(id obj)) having{
    return ^(id obj){
        [babysister->pocket setObject:obj forKey:NSStringFromClass([obj class])];
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



-(void)validateProcess{
    
    NSMutableArray *faildReason = [[NSMutableArray alloc]init];
    
    //规则：不执行discoverDescriptorsForCharacteristic()时，不能执行readValueForDescriptors()
    if (!babysister->needDiscoverDescriptorsForCharacteristic) {
        if (babysister->needReadValueForDescriptors) {
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
    
    //规则：不执行needScanForPeripherals()，那么执行connectToPeripheral()方法时必须用having(peripheral)传入peripheral实例
    if (!babysister->needScanForPeripherals) {
        CBPeripheral *peripheral = [babysister->pocket valueForKey:NSStringFromClass([CBPeripheral class])];
        if (!peripheral) {
            [faildReason addObject:@"若不执行scanForPeripherals()方法，则必须执行connectToPeripheral方法并且需要传入参数(CBPeripheral *)peripheral"];
        }
    }
    
    //抛出异常
    if ([faildReason lastObject]) {
        NSException *e = [NSException exceptionWithName:@"BadyBluetooth usage exception" reason:[faildReason lastObject]  userInfo:nil];
        @throw e;
    }
  
}

-(BabyBluetooth *) and{
    return self;
}
-(BabyBluetooth *) then{
    return self;
}
-(BabyBluetooth *) with{
    return self;
}

#pragma mark -工具方法
//断开连接
-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral{
    [babysister cancelPeripheralConnection:peripheral];
}
//断开所有连接
-(void)cancelAllPeripheralsConnection{
    [babysister cancelAllPeripheralsConnection];
}
//停止扫描
-(void)cancelScan{
    [babysister cancelScan];
}
//读取Characteristic的详细信息
-(BabyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) characteristicDetails{
    //切换频道
    [babySpeaker switchChannel:[babysister->pocket valueForKey:@"channel"]];
    babysister->pocket = [[NSMutableDictionary alloc]init];
    
    return ^(CBPeripheral *peripheral,CBCharacteristic *characteristic){
        //判断连接状态
        if (peripheral.state == CBPeripheralStateConnected) {
            self->babysister->oneReadValueForDescriptors = YES;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral discoverDescriptorsForCharacteristic:characteristic];
        }else{
            NSLog(@"!!!设备当前处于非连接状态");
        }
        
        return self;
    };
}

-(void)notify:(CBPeripheral *)peripheral
characteristic:(CBCharacteristic *)characteristic
        block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block{
    //设置通知
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    [babySpeaker addNotifyCallback:characteristic withBlock:block];
}
-(void)cancelNotify:(CBPeripheral *)peripheral
     characteristic:(CBCharacteristic *)characteristic{
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    [babySpeaker removeNotifyCallback:characteristic];
}



@end


