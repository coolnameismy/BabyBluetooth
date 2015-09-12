
![](http://images.jumppo.com/uploads/BabyBluetooth_logo.png)

The easiest way to use Bluetooth (BLE )in ios,even bady can use .  CoreBluetooth wrap.

#feature

- CoreBluetooth wrap，simple and eary for use.
- CoreBluetooth is dependency on delegate ,and most times,call method at delegate then go into delegate,and over and over,it's messy.BabyBluetooth favor to using block.
- call methor in a serial，it's  simple and graceful.
- using channel switch blcoks in a group.

current verison v0.2

# Contents

* [usage](#usage)
    * [QuickExample](#user-content-QuickExample)
    * [init](#user-content-init)
    * [scan for](#user-content-scan-for)
    * [scan for then connect](#user-content-scan-for-then-connect)
    * [connect direct](#user-content-connect-direct)
    * [disconnect and cancel](#user-content-disconnect-and-cancel)
    * [services characteristic description](#user-content-services-characteristic-description)
    * [characteristic and value then description and there‘s value](#user-content-characteristic and value then description-and-there‘s-value)
    * [subscript of characteristic](#user-content-subscript-of-characteristic)
    * [unsubscript of characteristic](#user-content-unsubscript-of-characteristic)
* [delegate](#user-content-delegate)
  	* [example](#user-content-example)
  	* [all delegate](#user-content-all-delegate)
  	* [delegate at channel](#user-content-delegate-at-channel)
  	* [default channel](#user-content-default-channel)
* [methor in serial](#user-content-methor-in-serial) 
    * [verb](#user-content-verb)
    * [sequence](#user-content-sequence)
* [how to install](#user-content-how-to-install)
* [demo explain](#user-content-demo-explain)
* [project struct](#user-content-project-struct)
* [Compatibility](#user-content-Compatibility)
* [plan for update](#user-content-plan-for-update)
* [wish](#user-content-wish)

# usage

## QuickExample
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


## init

```objc
    //Singleton, recommend
    BabyBluetooth *baby = [BabyBluetooth shareBabyBluetooth];
    //normal
    BabyBluetooth *baby = [[BabyBluetooth alloc]init];
```

## scanfor

```objc

    //scan for peripheral   
    baby.scanForPeripherals().begin();
    
    //scan for ten seconds and stop （disconnect peripheral and cancel scan for）
    baby.scanForPeripherals().begin().stop(10);
    
    //setting filter of discoverPeripheral
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length >2) {
            return YES;
        }
        return NO;
    }];

```

## scan for then connect

```objc
    
    /*
    *scan for then connect：1:setting filter 2：scan and connect
    */
    //1:setting filter
     __block BOOL isFirst = YES;
    [baby setFilterOnConnetToPeripherals:^BOOL(NSString *peripheralName) {
        //rule：first peripheral and name start with "AAA"
        if(isFirst && [peripheralName hasPrefix:@"AAA"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];

    //2：scan and connect
    baby.scanForPeripherals().connectToPeripherals().begin()

```

## connect direct

````objc
 baby.having(self.currPeripheral).connectToPeripherals().begin();
````

## disconnect and cancel

````objc
  
  //disconnect peripheral,peripheral is a instance of CBPeripheral
  [baby cancelPeripheralConnection:peripheral];
  
  //disconnect all peripheral
  [baby cancelAllPeripheralsConnection];
    
  //cancelScan
  [baby cancelScan];
  
````

## services_characteristic_description

discover services、characteristic、description and those value

````objc
  //set a peripheral then discoverServices,and then characteristics and its value，then characteristics’s description name and value
  //self.peripheral is a CBPeripheral instance
   baby.having(self.peripheral).connectToPeripherals().discoverServices().discoverCharacteristics()
   .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
   
````

## services_characteristic_description

````objc
  //self.peripheral and self.characteristic is instance
  baby.characteristicDetails(self.peripheral,self.characteristic);
````

## subscript of characteristic
````objc
            //self.peripheral and self.characteristic is instance
            [baby notify:self.currPeripheral
          characteristic:self.characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                //when receive
                NSLog(@"new value %@",characteristics.value);
     }];
````

## unsubscript of characteristic
````objc
  //self.peripheral and self.characteristic is instance
  [baby cancelNotify:self.peripheral characteristic:self.characteristic];
````


# delegate

## example

````objc

    //setting  delegate of discoverToPeripherals
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"has scan for peropheral:%@",peripheral.name);
    }];
    //setting delegate of peripheral connected
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"peripheral：%@connected",peripheral.name);
    }];
    
````

after setting delegate ,then execute serial

````objc

baby.scanForPeripherals().begin();

````

when  scan for a peripheral，or connected peripheral，it's into delegate on 


## all delegate

````objc

//====================================default channel delegate======================================
//when CentralManager state changed
-(void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block;
//when find peripheral
-(void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
//when connected peripheral
-(void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;
//when fail to connected peripheral
-(void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;
//when disconnected peripheral
-(void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;
//when discover services of peripheral
-(void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block;
//when discovered Characteristics
-(void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;
//when read new characteristics value 
-(void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//when discover descriptors for characteristic
-(void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//when read descriptors for characteristic
-(void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block;

//====================================channel delegate======================================
//channel
//when CentralManager state changed
-(void)setBlockOnCentralManagerDidUpdateStateAtChannel:(NSString *)channel
                                                        block:(void (^)(CBCentralManager *central))block;
//when find peripheral
-(void)setBlockOnDiscoverToPeripheralsAtChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;

//when connected peripheral
-(void)setBlockOnConnectedAtChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block;

//when fail to connected peripheral
-(void)setBlockOnFailToConnectAtChannel:(NSString *)channel
                                       block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

//when disconnected peripheral
-(void)setBlockOnDisconnectAtChannel:(NSString *)channel
                                    block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block;

//when discover services of peripheral
-(void)setBlockOnDiscoverServicesAtChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block;

//when discovered Characteristics
-(void)setBlockOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block;
//when read new characteristics value
-(void)setBlockOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block;
//when discover descriptors for characteristic
-(void)setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block;
//when read descriptors for characteristic
-(void)setBlockOnReadValueForDescriptorsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptorNSError,NSError *error))block;

//setting filter of discover peripherals
-(void)setFilterOnDiscoverPeripheralsAtChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName))filter;

//setting filter of connetTo peripherals
-(void)setFilterOnConnetToPeripheralsAtChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName))filter;
                                     

````

## delegate at channe
> delegate can switch by channel

usually in our app,more then one viewController want using bluetooth,you can setting delegate in defferent channel by group of setBlockOn...AtChannel method。and use ```` baby.channel(channelName) ```` to switch then.

example：
````objc

    //setting channel at “detailsView” when discover to peripheral
    NSString *channelName = @"detailsChannel";
    [baby setBlockOnDiscoverToPeripheralsAtChannel:channelName
          block:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
         NSLog(@"channel(%@) :搜索到了设备:%@",channelName,peripheral.name);
    }];
    
    //switch to channel 
    baby.channel(channelName)
    //execute
    .scanForPeripherals().begin();
    
````

##default channel
in serial method of baby.().().(), channel() can be everywhere but after begin(),if serial without channel(),
the channel in default channel.


#serial method

## verb 
in baby.().().() ， the verb method and,then,with can improve code readability 。

example：

````objc

  baby.having(self.p).and.channel(channelOnPeropheralView).
  then.connectToPeripherals().discoverServices().discoverCharacteristics()
  .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
  
````

## serial method sequence

serial method in baby.().().() according to corebluetooth’s sequence and limit . 
the sequence is scanfor->discover peripheral -> connect peripheral ->discover service ->discover characteristic->read characteristic value or discover characteristic's descriptors -> read descriptor's value

rule:
- begin() or stop() must end of serial
- having(),channel() must before begin()
- without peripheral having(instance of peripheral), connectToPeripherals() is forbid
- without connect peripheral ,discoverServices() is forbid
- without discoverServices() or discoverCharacteristics() , readValueForCharacteristic() 、discoverDescriptorsForCharacteristic()、readValueForDescriptors() is forbid
- without discoverCharacteristics()，readValueForCharacteristic() or discoverDescriptorsForCharacteristic() is forbid
- without discoverDescriptorsForCharacteristic(),readValueForDescriptors() is forbid


# how to install

##1 manual
step1: let src folder‘s files import your project

step2:import .h

````objc
#import "BabyBluetooth.h"
````

##2 cocoapods
not support for now


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

- 
# project struct
- BabyBluetooth: implement serial method, also is BabyBluetooth facade
- Babysister： centralManager delegate calss ，it's handler serial method and implement dilter and block callback
- BabySpeaker: implement chanel of block get and set
- BabyCallback: block and filter's model
- BabyToy: util method

# compatibility
- Bluetooch 4.0，another name is BLE，ios6 free access
- both os and ios
- in ios app,it's can be ues in simulator

# next verison
- add support to peripheralManager Mode（for now，it's only support centralManager mode）

history verison，see wiki

# ios bluetooth learning resource(chinese)
- [ios蓝牙开发（一）蓝牙相关基础知识](http://liuyanwei.jumppo.com/2015/07/17/ios-BLE-1.html)
- [ios蓝牙开发（二）蓝牙中心模式的ios代码实现](http://liuyanwei.jumppo.com/2015/08/14/ios-BLE-2.html)
- [ios蓝牙开发（三）app作为外设被连接的实现](http://liuyanwei.jumppo.com/2015/08/14/ios-BLE-3.html)
- [ios蓝牙开发（四）BabyBluetooth蓝牙库介绍](http://liuyanwei.jumppo.com/2015/09/07/ios-BLE-4.html)
- 暂未完成-ios蓝牙开发（五）BabyBluetooth实现原理
- to be continue...

# wish
  - coding BabyBluetooth is work hard , wish audience star BabyBluetooch for support 
  - if find bug or function is not enough,please issues me
  - wish everyone join BabyBluetooth and active pull requests 。my code is only just beginning and it have lot of area for improvements。
  - wish learning,communicating,growing with yours by pull requests in BabyBluetooch 
  - english grammar issue, please help for fix
  - thanks
 
