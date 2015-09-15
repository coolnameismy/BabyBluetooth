//
//  BabyBeats.h
//  BabyBluetoothAppDemo
//
//  Created by ZTELiuyw on 15/9/15.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BabyRhythm : NSObject


typedef void (^BBBeatsBreakBlock)(BabyRhythm *bry);
typedef void (^BBBeatsOverBlock)(BabyRhythm *bry);

//timer for beats
@property(nonatomic,strong) NSTimer *beatsTimer;

//beat interval
@property int beatsInterval;


#pragma mark beats
-(void)beats;
-(void)beatsBreak;
-(void)beatsOver;
-(void)beatsRestart;

-(void)setBlockOnBeatsBreak:(void(^)(BabyRhythm *bry))block;
-(void)setBlockOnBeatsOver:(void(^)(BabyRhythm *bry))block;



@end
