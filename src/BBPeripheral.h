//
//  SBPeripheral.h
//  PlantAssistant
//
//  Created by ZTELiuyw on 15/7/17.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "Babysister.h"
#import "BabyToy.h"
#import "BabyCallback.h"
 




@interface BBPeripheral : NSObject{
    
@public

    BBConnectedPeripheralBlock connectedBlock;
    BBFailToConnectBlock failToConnectBlock;
    BBDisconnectBlock disConnectBlock;
    BBDiscoverServicesBlock discoverServiceslock;
    CBPeripheral *CBperipheral;

}


-(instancetype)initWithSBPeripheral:(CBPeripheral *)peripheral;



@end
