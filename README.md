
![](http://images.jumppo.com/uploads/BabyBluetooth_logo.png)

The easiest way to use Bluetooth (BLE )in ios,even bady can use. 简单易用的蓝牙库，基于CoreBluetooth的封装，并兼容ios和mac osx.

**为什么使用它？**

- 1：基于原生CoreBluetooth框架封装的轻量级的开源库，可以帮你更简单地使用CoreBluetooth API。
- 2：CoreBluetooth所有方法都是通过委托完成，代码冗余且顺序凌乱。BabyBluetooth使用block方法，可以重新按照功能和顺序组织代码，并提供许多方法减少蓝牙开发过程中的代码量。
- 3:链式方法体，代码更简洁、优雅。
- 4:通过channel切换区分委托调用，并方便切换
- 5:便利的工具方法
- 6:完善的文档，且项目处于活跃状态，不断的更新中
- 7:github上star最多的纯Bluetooth类库
- 8:包含多种类型的demo和ios蓝牙开发教程
- 9:同时支持蓝牙设备中心模式和外设模式（central model and peripheral model）

当前版本 0.6.0

详细文档请参考wiki The full documentation of the project is available on its wiki.
# [english readme link,please click it!](https://github.com/coolnameismy/BabyBluetooth/blob/master/README_en.md)

# Table Of Contents

* [QuickExample](#user-content-QuickExample)
* [如何安装](#如何安装)
* [如何使用](#如何使用)
* [示例程序说明](#示例程序说明)
* [兼容性](#兼容性)
* [后期更新](#后期更新)
* [蓝牙学习资源](#蓝牙学习资源)
* [期待](#期待)

# QuickExample

## 中心模式 central model 
>   app作为中心，连接其他BLE4.0外设

```objc

//导入.h文件和系统蓝牙库的头文件
#import "BabyBluetooth.h"
//定义变量
BabyBluetooth *baby;

-(void)viewDidLoad {
    [super viewDidLoad];

    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
    baby.scanForPeripherals().begin();
}

//设置蓝牙委托
-(void)babyDelegate{

    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
   
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备 most common usage is discover for peripheral that name has common prefix
        //if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //    return YES;
        //}
        //return NO;
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];

    //.......
}

```

更多蓝牙操作方法和委托请参考[wiki](https://github.com/coolnameismy/BabyBluetooth/wiki)

中心模式使用示例请参考:[BabyBluetoothAppDemo](https://github.com/coolnameismy//BabyBluetoothExamples/BabyBluetoothAppDemo)

## 外设模式 peripheral model 
>   app模拟一个，BLE4.0外设，可以被其他设备连接和使用


模拟一个有2个service和6个characteristic的外设

````objc
//导入.h文件和系统蓝牙库的头文件
#import "BabyBluetooth.h"
//定义变量
BabyBluetooth *baby;

-(void)viewDidLoad {
    [super viewDidLoad];

    //配置第一个服务s1
    CBMutableService *s1 = makeCBService(@"FFF0");
    //配置s1的3个characteristic
    makeCharacteristicToService(s1, @"FFF1", @"r", @"hello1");//读
    makeCharacteristicToService(s1, @"FFF2", @"w", @"hello2");//写
    makeCharacteristicToService(s1, genUUID(), @"rw", @"hello3");//可读写,uuid自动生成
    makeCharacteristicToService(s1, @"FFF4", nil, @"hello4");//默认读写字段
    makeCharacteristicToService(s1, @"FFF5", @"n", @"hello5");//notify字段
    //配置第一个服务s2
    CBMutableService *s2 = makeCBService(@"FFE0");
    makeStaticCharacteristicToService(s2, genUUID(), @"hello6", [@"a" dataUsingEncoding:NSUTF8StringEncoding]);//一个含初值的字段，该字段权限只能是只读
   
    //实例化baby
    baby = [BabyBluetooth shareBabyBluetooth];
    //配置委托
    [self babyDelegate];
    //启动外设
    baby.bePeripheral().addServices(@[s1,s2]).startAdvertising();
}

//设置蓝牙外设模式的委托
-(void)babyDelegate{

     //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnPeripheralManagerDidUpdateState:^(CBPeripheralManager *peripheral) {
        NSLog(@"PeripheralManager trun status code: %ld",(long)peripheral.state);
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidStartAdvertising:^(CBPeripheralManager *peripheral, NSError *error) {
        NSLog(@"didStartAdvertising !!!");
    }];
    
    //设置添加service委托 | set didAddService block
    [baby peripheralModelBlockOnDidAddService:^(CBPeripheralManager *peripheral, CBService *service, NSError *error) {
        NSLog(@"Did Add Service uuid: %@ ",service.UUID);
    }];

    //.....
}

````
  
更多蓝牙外设模式委托请参考[wiki](https://github.com/coolnameismy/BabyBluetooth/wiki)

中心模式使用示例请参考:[BluetoothStubOnIOS](https://github.com/coolnameismy//BabyBluetoothExamples/BluetoothStubOnIOS)

# 如何安装

##1 手动安装
step1:将项目Classes/objc 文件夹中的文件直接拖入你的项目中即可

step2:导入.h文件

````objc
#import "BabyBluetooth.h"
````

##2 cocoapods
step1:add the following line to your Podfile:
````
pod 'BabyBluetooth','~> 0.6.0'
````

step2:导入.h文件
````objc
#import "BabyBluetooth.h"
````

# 如何使用
[用法请见wiki](https://github.com/coolnameismy/BabyBluetooth/wiki)

# 示例程序说明

**BabyBluetoothExamples/BabyBluetoothAppDemo** :一个类似lightblue的程序，蓝牙操作全部使用BabyBluetooth完成。
功能：
- 1：扫描周围设备
- 2：连接设备，扫描设备的全部services和characteristic
- 3：显示characteristic，读取characteristic的value，和descriptors以及Descriptors对应的value
- 4：写0x01到characteristic
- 5：订阅/取消订阅 characteristic的notify

**BabyBluetoothExamples/BluetoothStubOnIOS** : 一个iOS程序，启动后会用手机模拟一个外设，提供2个服务和若干characteristic。
该程序作为Babybluetooth 外设模式使用的示例程序

**BabyBluetoothExamples/BabyBluetoothOSDemo** :一个mac os程序，因为os和ios的蓝牙底层方法都一样，所以BabyBluetooth可以ios/os通用。但是os程序有个好处就是直接可以在mac上跑蓝牙设备，不像ios，必须要真机才能跑蓝牙设备。所以不能真机调试时可以使用os尝试蓝牙库的使用。

功能：
- 1：扫描周围设备、连接设备、显示characteristic，读取characteristic的value，和descriptors以及Descriptors对应的value的委托设置，并使用nslog打印信息。

**BabyBluetoothExamples/BluetoothStubOnOSX** :一个mac os程序，该程序可以作为蓝牙外设使用，解决学习蓝牙时没有外设可用的囧境，并且可以作为peripheral model模式的学习示例。改程序用swift编码。




功能：
- 1：作为蓝牙外设使用，可以被发现，连接，读写，订阅
- 2：提供1个service，包含了3个characteristic，分别具有读、读写、订阅功能

# 兼容性
- 蓝牙4.0，也叫做ble，ios6以上和iPhone4s以上可以自由使用
- os和ios通用
- 蓝牙设备相关程序必须使用真机才能运行。如果不能使用真机调试的情况，可以使用os程序调试蓝牙。可以参考示例程序中的BabyBluetoothOSDemo
- 本项目和示例程序是使用ios 8.3开发，使用者可以自行降版本，但必须大于6.0 



# 后期更新

- 优化babyBluetooch的子类类名
- 增加对Carthage Install的支持
- swift版本开发

已经更新的版本说明，请在wiki中查看

# 蓝牙学习资源
>  温馨提示：零基础做蓝牙开发很困难，所以就算使用babybluetooth降低了代码量,仍然任很有必要花上几天时间把蓝牙的基础概念弄明白后才开始动手~

- [ios蓝牙开发（一）蓝牙相关基础知识](http://liuyanwei.jumppo.com/2015/07/17/ios-BLE-1.html)
- [ios蓝牙开发（二）蓝牙中心模式的ios代码实现](http://liuyanwei.jumppo.com/2015/08/14/ios-BLE-2.html)
- [ios蓝牙开发（三）app作为外设被连接的实现](http://liuyanwei.jumppo.com/2015/09/07/ios-BLE-3.html)
- [ios蓝牙开发（四）BabyBluetooth蓝牙库介绍](http://liuyanwei.jumppo.com/2015/09/11/ios-BLE-4.html)
- 暂未完成-ios蓝牙开发（五）BabyBluetooth实现原理
- 待定...
- [官方CoreBuetooth支持页](https://developer.apple.com/bluetooth)
- [Bluetooth Accessory Design Guidelines for Apple Products](https://developer.apple.com/hardwaredrivers/BluetoothDesignGuidelines.pdf)

qq交流群4: 313084771
qq交流群3：530142592(满）
qq交流群2：168756967(满）
qq交流群1：426603940(满)

# 期待

  - 蓝牙库写起来很辛苦，不要忘记点击右上角小星星star和[follow](https://github.com/coolnameismy)支持一下~
  - 如果在使用过程中遇到BUG，或发现功能不够用，希望你能Issues我，谢谢
  - 期待大家也能一起为BabyBluetooth输出代码，这里我只是给BabyBluetooth开了个头，他可以增加和优化的地方还是非常多。也期待和大家在Pull Requests一起学习，交流，成长。


