//
//  BabyClothes.h
//  BabyBluetoothAppDemo
//
//  Created by 刘彦玮 on 15/9/27.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BabyOptions : NSObject

#pragma mark -属性
/*!
 * 扫描参数,centralManager:scanForPeripheralsWithServices:self.scanForPeripheralsWithServices options:self.scanForPeripheralsWithOptions
 * @param An optional dictionary specifying options for the scan.
 *  @see                centralManager:scanForPeripheralsWithServices
 *  @seealso            CBCentralManagerScanOptionAllowDuplicatesKey :忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
 *	@seealso			CBCentralManagerScanOptionSolicitedServiceUUIDsKey
 */
@property(nonatomic,strong) NSDictionary *scanForPeripheralsWithOptions;

/*!
*  连接设备的参数
*  @method connectPeripheral:options:
*  @param              An optional dictionary specifying connection behavior options.
*  @see                centralManager:didConnectPeripheral:
*  @see                centralManager:didFailToConnectPeripheral:error:
*  @seealso            CBConnectPeripheralOptionNotifyOnConnectionKey
*  @seealso            CBConnectPeripheralOptionNotifyOnDisconnectionKey
*  @seealso            CBConnectPeripheralOptionNotifyOnNotificationKey
*/
@property(nonatomic,strong) NSDictionary *connectPeripheralWithOptions;



/*!
 * 扫描参数,centralManager:scanForPeripheralsWithServices:self.scanForPeripheralsWithServices options:self.scanForPeripheralsWithOptions
 *@param serviceUUIDs A list of <code>CBUUID</code> objects representing the service(s) to scan for.
 *@see                centralManager:scanForPeripheralsWithServices
 */
@property(nonatomic,strong) NSArray *scanForPeripheralsWithServices;

// [peripheral discoverServices:self.discoverWithServices];
@property(nonatomic,strong) NSArray *discoverWithServices;

// [peripheral discoverCharacteristics:self.discoverWithCharacteristics forService:service];
@property(nonatomic,strong) NSArray *discoverWithCharacteristics;


#pragma mark -构造方法
-(instancetype)initWithscanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions
                        connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions;

-(instancetype)initWithscanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions
                        connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions
                      scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                                discoverWithServices:(NSArray *)discoverWithServices
                         discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics;

@end
