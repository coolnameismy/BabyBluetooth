//
//  BabySpeaker.h
//  BabyBluetoothDemo
//
//  Created by 刘彦玮 on 15/9/2.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyCallback.h"

@interface BabySpeaker : NSObject

-(BabyCallback *)callback;
-(BabyCallback *)callbackOnCurrChannel;
-(BabyCallback *)callbackOnChnnel:(NSString *)channel;
-(BabyCallback *)callbackOnChnnel:(NSString *)channel
               createWhenNotExist:(BOOL)createWhenNotExist;


-(void)switchChannel:(NSString *)channel;

@end
