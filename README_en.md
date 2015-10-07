
![](http://images.jumppo.com/uploads/BabyBluetooth_logo.png)

The easiest way to use Bluetooth (BLE )in ios,even bady can use .  CoreBluetooth wrap.

#feature

- 1:CoreBluetooth wrap，simple and eary for use.
- 2:CoreBluetooth is dependency on delegate ,and most times,call method at delegate then go into delegate,and over and over,it's messy.BabyBluetooth favor to using block.
- 3:call methor in a serial，it's  simple and graceful.
- 4:using channel switch blcoks in a group.
- 5:convenience tools class
- 6:comprehensive documentation and active project
- 7:more star library for ios bluetooch in github（not PhoneGap and SensorTag）
- 8:include demo and tutorial

current verison v0.3.0

# Contents

 
* [QuickExample](#user-content-QuickExample)
* [how to install](#user-content-how-to-install)
* [how to use](#user-content-how-to-use)
* [demo explain](#user-content-demo-explain)
* [Compatibility](#user-content-Compatibility)
* [plan for update](#user-content-plan-for-update)
* [wish](#user-content-wish)
 
# QuickExample
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
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
}
  
```

# how to install

##1 manual
step1: let src folder‘s files import your project

step2:import .h

````objc
#import "BabyBluetooth.h"
````

##2 cocoapods
step1:add the following line to your Podfile:
````
pod 'BabyBluetooth','~> 0.3.0'
````

step2:导入.h文件
````objc
#import "BabyBluetooth.h"
````

# how to use
[please see wiki](https://github.com/coolnameismy/BabyBluetooth/wiki)


# demo explain
**BabyBluetoothExamples/BabyBluetoothAppDemo** :similar to lightblue ,implement by BabyBluetooch

functionality
- 1：scan for nearby bluetooch peripheral
- 2：cannect and discover peripheral’s services and characteristic
- 3：read characteristic and characteristic‘s value,and descriptors or descriptors's value
- 4：write 0x01 to characteristic
- 5：subscription/unsubscription characteristic

**BabyBluetoothExamples/BabyBluetoothOSDemo** :mac osx app，osx and ios is not diffent on CoreBluetooth，so BabyBluetooth can use in both ios and osx 。
functionality
- 1：scanfor peripheral, conncet peripheral 、read characteristic，read characteristic 's value,discover descriptors and descriptors's value，the message all in nslog,this app none UI

**BabyBluetoothExamples/BluetoothStubOnOSX** :mac os app 。it can act a bluetooth peripheral.this app solve that learning Bluetooch but without periphera。and it also can be a demo and learing peripheral model program 。it write by swift

functionality
- 1：be a bluetooch peripheral，and can be scaned ,connected,writed,readed,subscibe by CBCentralManager
- 2：provide a service and contian three characteristic,each has one of read,write,subscibe permission

# compatibility
- Bluetooch 4.0，another name is BLE，ios6 free access
- both os and ios
- in ios app,it's can be ues in simulator

# plan for update
 
- add support for NSNotification event in babyBluetooth
- improve englist code note 
- add support for peripheralManager(let app be a peripheral!)
- add stub application to example,be act as peripheral for test
- babybluetooth test application
- support rssi to read


history verison，see wiki


# wish
  - coding BabyBluetooth is work hard , wish audience star BabyBluetooch for support 
  - if find bug or function is not enough,please issues me
  - wish everyone join BabyBluetooth and active pull requests 。my code is only just beginning and it have lot of area for improvements。
  - wish learning,communicating,growing with yours by pull requests in BabyBluetooch 
  - english grammar issue, please help for fix
  - thanks
 
