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

//心跳时间间隔，默认是3
//defalut interval
#define beatsDefaultInterval 3;



#pragma mark beats
//心跳
-(void)beats;
//主动中断心跳
-(void)beatsBreak;
//结束心跳，结束后会进入BlockOnBeatOver，并且结束后再不会在触发BlockOnBeatBreak
-(void)beatsOver;
//恢复心跳，beatsOver操作后可以使用beatsRestart恢复心跳，恢复后又可以进入BlockOnBeatBreak方法
-(void)beatsRestart;

//心跳中断的委托
-(void)setBlockOnBeatsBreak:(void(^)(BabyRhythm *bry))block;
//心跳结束的委托
-(void)setBlockOnBeatsOver:(void(^)(BabyRhythm *bry))block;



@end
