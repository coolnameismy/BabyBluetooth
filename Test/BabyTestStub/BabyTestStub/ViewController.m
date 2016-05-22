//
//  ViewController.m
//  BabyTestStub
//
//  Created by ZTELiuyw on 16/3/14.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import "ViewController.h"
#import "BabyBluetooth.h"



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAndStartAd];
   
}

-(void) configAndStartAd {
    //配置第一个服务s1
    CBMutableService *s1 = makeCBService(@"FFF0");
    //配置s1的3个characteristic
    makeCharacteristicToService(s1, @"FFF1", @"r", @"hello1");//读
    makeCharacteristicToService(s1, @"FFF2", @"w", @"hello2");//写
    makeCharacteristicToService(s1, genUUID(), @"rw", @"hello3");//读写,自动生成uuid
    makeCharacteristicToService(s1, @"FFF4", nil, @"hello4");//默认读写字段
    makeCharacteristicToService(s1, @"FFF5", @"n", @"hello5");//notify字段
    //配置第一个服务s2
    CBMutableService *s2 = makeCBService(@"FFE0");
    makeStaticCharacteristicToService(s2, genUUID(), @"hello6", [@"a" dataUsingEncoding:NSUTF8StringEncoding]);//一个含初值的字段，该字段权限只能是只读
    //实例化baby
    self.baby = [BabyBluetooth shareBabyBluetooth];
    //配置委托
    [self babyDelegate];
    //添加服务和启动外设
    //    self.baby.bePeripheral().addServices(@[s1,s2]).startAdvertising();
    
    //设置广播包数据
    NSData *data = [[NSData alloc]initWithBase64EncodedString:@"qAEgECCVXQuEVSHedFvlQc5g5ivB" options:0];
    
    self.baby.bePeripheralWithName(@"BabyBluetoothTestStub").addServices(@[s1,s2]).addManufacturerData(data).startAdvertising();
    
    
    /**
       模拟外设信息
      
       localName = BabyBluetoothTestStub
       uuid: 不固定
       alink协议隐藏的mac地址:C1:2B:E6:60:CE:41
     
       services and characteristics
         FFF0
            - FFF1 ， FFF2 ，FFF3
            - 一个随机的uuid
            - FFF5 是notiy字段，返回当前时间
         FFE0
            - 一个随机的只读uuid
     **/
    
    
    
}
//配置委托
- (void)babyDelegate{
    
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
        NSLog(@"PeripheralManager trun status code: %ld",(long)peripheral.state);
        if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
//           [self configAndStartAd];
        }
    }];
    
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidStartAdvertising:^(CBPeripheralManager *peripheral, NSError *error) {
        NSLog(@"didStartAdvertising !!!");
    }];
    
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidAddService:^(CBPeripheralManager *peripheral, CBService *service, NSError *error) {
        NSLog(@"Did Add Service uuid: %@ ",service.UUID);
    }];
    
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidReceiveReadRequest:^(CBPeripheralManager *peripheral,CBATTRequest *request) {
        NSLog(@"request characteristic uuid:%@",request.characteristic.UUID);
        //判断是否有读数据的权限
        if (request.characteristic.properties & CBCharacteristicPropertyRead) {
            NSData *data = request.characteristic.value;
            [request setValue:data];
            //对请求作出成功响应
            [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
        }else{
            //错误的响应
            [peripheral respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
    }];
    
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidReceiveWriteRequests:^(CBPeripheralManager *peripheral,NSArray *requests) {
        CBATTRequest *request = requests[0];
        NSLog(@"didReceiveWriteRequests: value:%@",request.value);
        //判断是否有写数据的权限
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            //需要转换成CBMutableCharacteristic对象才能进行写值
            CBMutableCharacteristic *c =(CBMutableCharacteristic *)request.characteristic;
            c.value = request.value;
            [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
        }else{
            [peripheral respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
        
    }];
    
    __block NSTimer *timer;
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidSubscribeToCharacteristic:^(CBPeripheralManager *peripheral, CBCentral *central, CBCharacteristic *characteristic) {
        NSLog(@"订阅了 %@的数据",characteristic.UUID);
        if (characteristic.isNotifying) {
            return;
        }
        //每秒执行一次给主设备发送一个当前时间的秒数
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendData:) userInfo:characteristic  repeats:YES];
    }];
    
    //设置添加service委托 | set didAddService block
    [self.baby peripheralModelBlockOnDidUnSubscribeToCharacteristic:^(CBPeripheralManager *peripheral, CBCentral *central, CBCharacteristic *characteristic) {
        NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
        [timer fireDate];
    }];
    
}

//发送数据，发送当前时间的秒数
-(BOOL)sendData:(NSTimer *)t {
    CBMutableCharacteristic *characteristic = t.userInfo;
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:@"ss"];
    //    NSLog(@"%@",[dft stringFromDate:[NSDate date]]);
    //执行回应Central通知数据
    return  [self.baby.peripheralManager updateValue:[[dft stringFromDate:[NSDate date]] dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:(CBMutableCharacteristic *)characteristic onSubscribedCentrals:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
