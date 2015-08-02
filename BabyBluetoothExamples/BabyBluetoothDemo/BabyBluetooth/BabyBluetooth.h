//
//  GAAT.h
//  PlantAssistant
//
//  Created by 刘彦玮 on 15/3/31.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
// simple

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BBCentralManager.h"
#import "Babysister.h"
#import "BabyToy.h"



typedef NS_ENUM(NSInteger, BabyStatus) {
    BabyStatusStop = 0,
    BabyStatusRuning
};

@interface BabyBluetooth : NSObject<CBPeripheralDelegate>{
    
    @private
    //主设备
    BBCentralManager *bleManager;
    //BabyStatus;
    BabyStatus babyStatus;
  
    //线程
    dispatch_semaphore_t peripheralsSemaphore;
    dispatch_queue_t simpleBleQueue;
}

#pragma mark -属性 property


 
//从设备数组
@property (strong, nonatomic) NSMutableDictionary *peripherals;

//通知、委托、block处理
//@property (strong, nonatomic) Babysister *babysister;



//超时时间
#define BLEtTimeout 30




#pragma mark -设置委托方法

//找到Peripherals的委托
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
//连接Peripherals成功的委托
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;
//设置查找服务回叫
-(void)setBlockOndDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block;

//设置查找Peripherals的规则
-(void)setDiscoverPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter;
//设置连接Peripherals的规则
-(void)setConnectPeripheralsFilter:(BOOL (^)(NSString *peripheralsFilter))filter;


#pragma mark -链式函数
//查找Peripherals
-(BabyBluetooth *(^)()) scanForPeripherals;
//连接Peripherals
-(BabyBluetooth *(^)()) connectToPeripheral;
-(BabyBluetooth *(^)()) connectToPeripheral:(CBPeripheral *)peripheral;
//发现Services
-(BabyBluetooth *(^)()) discoverServices;
//获取Characteristics
-(BabyBluetooth *(^)()) discoverCharacteristics;
//开始执行
-(BabyBluetooth *(^)()) begin;
//开始并执行sec秒后停止
-(BabyBluetooth *(^)()) begin:(int)sec;
//停止
-(void(^)()) stop;

-(BabyBluetooth *) and;
-(BabyBluetooth *) then;


/**
 * 单例构造方法
 * @return SimpleBLE共享实例
 */
+(instancetype)shareSimpleBLE; 


/**
 * 默认时间内（10秒）扫描出周围的设备
 * @return 扫描到的设备列表 NSMutableArray<CBPeripheral>
 */
//-(NSMutableArray *) scanForPeripherals;

/**
 * 给定时间内扫描出周围的设备，
 * @warning 该方法是线程同步方法完成，须用异步方式调用，否则会造成线程柱塞
 * @see 相同功能的异步版本 scanForPeripheralsWithBlock:(SBDiscoverToPeripheralsBlock)discoverBlock
 * @param scanTime 给定的时间，单位为秒
 * @return 扫描到的设备列表 NSMutableArray<CBPeripheral>
 */
-(NSMutableArray *)scanForPeripheralsInSecond:(int)scanTime;

/**
 *  查找设备
 *
 *  @param findPeripheralsBlock discoverPeripheral
 *
 *  @return <#return value description#>
 */
-(void) scanForPeripheralsWithBlock:(BBDiscoverToPeripheralsBlock)discoverPeripheralBlock;


/**
 *  连接设备
 */
-(void) connectToPeripheral:(NSString *)peripheralName succeedBlock:(BBConnectedPeripheralBlock)succeedBlock failedBlock:(BBFailToConnectBlock)failedBlock disconnectBlock:(BBDisconnectBlock)disconnectBlock;

/**
 *  连接设备并扫描服务
 */
-(void) connectToPeripheral:(NSString *)peripheralName
               succeedBlock:(BBConnectedPeripheralBlock)succeedBlock
                failedBlock:(BBFailToConnectBlock)failedBlock
            disconnectBlock:(BBDisconnectBlock)disconnectBlock
      discoverServicesBlock:(BBDiscoverServicesBlock)discoverServicesBlock;


/**
 *  找到设备服务
 */
//-(void) scanServices:(CBPeripheral *)peripheral succeed:(SBDiscoverServicesBlock)succeed;


#pragma mark -测试使用

/**
 *  测试
 */
@property(strong,nonatomic) CBPeripheral *testPeripheral;


-(int (^)(int a,int b)) add;
//- (MASConstraint * (^)(id attr))equalTo;

@end
