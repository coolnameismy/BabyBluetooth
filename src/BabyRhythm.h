//
//  BabyBeats.h
//  BabyBluetoothAppDemo
//
//  Created by ZTELiuyw on 15/9/15.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^BBBeatsBreakBlock)();
typedef void (^BBBeatsOverBlock)();

@interface BabyRhythm : NSObject


//timer for beats
@property(nonatomic,strong) NSTimer *beatsTimer;

////beats block
//@property(nonatomic,strong) BBBeatsBreakBlock blockOnBeatBreak;
//@property(nonatomic,strong) BBBeatsOverBlock blockOnBeatOver;

//beat interval
@property int beatsInterval;


#pragma mark beats
-(void)beats;
-(void)beatsBreak;
-(void)beatsOver;
-(void)beatsRestart;

-(void)setBlockOnBeatBreak:(void(^)())block;
-(void)setBlockOnBeatOver:(void(^)())block;

//
//-(void)beats{
//    NSLog(@">>>beats at :%@",[NSDate date]);
//    [serialBeat setFireDate: [[NSDate date]dateByAddingTimeInterval:self.serialBeatInterval]];
//}
//
//-(void)beatsBreak{
//    NSLog(@">>>beatsBreak :%@",[NSDate date]);
//    serialBeat = nil;
//    //回调
//    if ([currChannel blockOnBeatsBreak]) {
//        [currChannel blockOnBeatsBreak]
//        ([bleManager retrieveConnectedPeripheralsWithServices:nil]);
//    }
//}


@end
