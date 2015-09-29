
![](http://images.jumppo.com/uploads/BabyBluetooth_logo.png)

The easiest way to use Bluetooth (BLE )in ios,even bady can use .  CoreBluetooth wrap.

#feature

- CoreBluetooth wrap，simple and eary for use.
- CoreBluetooth is dependency on delegate ,and most times,call method at delegate then go into delegate,and over and over,it's messy.BabyBluetooth favor to using block.
- call methor in a serial，it's  simple and graceful.
- using channel switch blcoks in a group.

current verison v0.2

# Contents

 
* [QuickExample](#user-content-QuickExample)
* [how to install](#user-content-how-to-install)
* [how to use](https://github.com/coolnameismy/BabyBluetooth/wiki)
* [demo explain](#user-content-demo-explain)
* [Compatibility](#user-content-Compatibility)
* [plan for update](#user-content-plan-for-update)
* [wish](#user-content-wish)
 
# QuickExample
```objc

//import header file
#import "BabyBluetooth.h"

-(void)viewDidLoad {
    [super viewDidLoad];

    //get babyBluetooth instance
    baby = [BabyBluetooth shareBabyBluetooth];
    //setting delegate
    [self babyDelegate];
    //just use it，no need wait CBCentralManagerStatePoweredOn
    baby.scanForPeripherals().begin();
}

//setting delegate
-(void)babyDelegate{

    //delegate of DiscoverToPeripherals
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"discovered peripheral:%@",peripheral.name);
    }];
   
    //Filter
    //setting filter of discoverPeripheral
    [baby setDiscoverPeripheralsFilter:^BOOL(NSString *peripheralsFilter) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralsFilter.length >1) {
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
to be soon

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

# compatibility
- Bluetooch 4.0，another name is BLE，ios6 free access
- both os and ios
- in ios app,it's can be ues in simulator

# plan for update
 
- add support for notifiy event in babyBluetooth
- improve englist code note 
- add support for app run in background
- add support for peripheralManager(let app be a peripheral!)
- pod install
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
 
