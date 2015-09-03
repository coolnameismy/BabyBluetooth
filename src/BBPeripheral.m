//
//  SBPeripheral.m
//  PlantAssistant
//
//  Created by 刘彦玮 on 15/7/17.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BBPeripheral.h"

@implementation BBPeripheral



-(instancetype)initWithSBPeripheral:(CBPeripheral *)peripheral{
    
    self = [super init];
    
    
    if (self) {
        self->CBperipheral = peripheral;
    }

    return self;
}

@end
