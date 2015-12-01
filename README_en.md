
![](http://images.jumppo.com/uploads/BabyBluetooth_logo.png)

The easiest way to use Bluetooth (BLE )in ios,even bady can use .  CoreBluetooth wrap.

#feature

- 1:CoreBluetooth wrap，simple and eary for use.
- 2:CoreBluetooth is dependency on delegate ,and most times,call method at delegate then go into delegate,and over and over,it's messy.BabyBluetooth favor to using block.
- 3:call methor in a serial，it's  simple and elegant syntax.
- 4:using channel switch blcoks in a group.
- 5:convenience tools class
- 6:comprehensive documentation and active project
- 7:more star library for ios bluetooch in github（not PhoneGap and SensorTag）
- 8:include demo and tutorial

current verison v0.4.0

# Contents

 
* [QuickExample](#user-content-QuickExample)
* [how to install](#user-content-how-to-install)
* [how to use](#user-content-how-to-use)
* [demo explain](#user-content-demo-explain)
* [Compatibility](#user-content-Compatibility)
* [plan for update](#user-content-plan-for-update)
* [Community with US](#user-content-community with us)
* [wish](#user-content-wish)
 
# QuickExample
```objc

//import head files
#import "BabyBluetooth.h"
//define var
BabyBluetooth *baby;

-(void)viewDidLoad {
    [super viewDidLoad];

    //init BabyBluetooth
    baby = [BabyBluetooth shareBabyBluetooth];
    //set delegate
    [self babyDelegate];
    //direct use，no longer wait for status Of CBCentralManagerStatePoweredOn
    baby.scanForPeripherals().begin();
}

//set babybluetooth delegate
-(void)babyDelegate{

    //when scanfor perihpheral
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
   
    //filter
    //discover peripherals filter
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
pod 'BabyBluetooth','~> 0.4.0'
````

step2:import header files
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
- babybluetooth test application
- swift babybluetooth develop

history verison，see wiki

# Community with US
QQ Group Number:168756967. [QQ is a IM from china](http://im.qq.com/)

Or Mail me:coolnameismy@hotmail.com


# wish
  - coding BabyBluetooth is work hard , wish audience star BabyBluetooch for support 
  - if find bug or function is not enough,please issues me
  - wish everyone join BabyBluetooth and active pull requests 。my code is only just beginning and it have lot of area for improvements。
  - wish learning,communicating,growing with yours by pull requests in BabyBluetooch 
  - english grammar issue, please help for fix
  - thanks
 
