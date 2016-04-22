//
//  BabyBeats.m
//  BabyBluetoothAppDemo
//
//  Created by ZTELiuyw on 15/9/15.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyRhythm.h"
#import "BabyDefine.h"

@implementation BabyRhythm {
    BOOL isOver;
    BBBeatsBreakBlock blockOnBeatBreak;
    BBBeatsOverBlock blockOnBeatOver;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //beatsInterval
        _beatsInterval = KBABYRHYTHM_BEATS_DEFAULT_INTERVAL;
    }
    return  self;
}

- (void)beats {
    
    if (isOver) {
        BabyLog(@">>>beats isOver");
        return;
    }
    
    BabyLog(@">>>beats at :%@",[NSDate date]);
    if (self.beatsTimer) {
        [self.beatsTimer setFireDate: [[NSDate date]dateByAddingTimeInterval:self.beatsInterval]];
    }
    else {
       self.beatsTimer = [NSTimer timerWithTimeInterval:self.beatsInterval target:self selector:@selector(beatsBreak) userInfo:nil repeats:YES];
        [self.beatsTimer setFireDate: [[NSDate date]dateByAddingTimeInterval:self.beatsInterval]];
        [[NSRunLoop currentRunLoop] addTimer:self.beatsTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)beatsBreak {
     BabyLog(@">>>beatsBreak :%@",[NSDate date]);
    [self.beatsTimer setFireDate:[NSDate distantFuture]];
    if (blockOnBeatBreak) {
        blockOnBeatBreak(self);
    }
}

- (void)beatsOver {
    BabyLog(@">>>beatsOver :%@",[NSDate date]);
    [self.beatsTimer setFireDate:[NSDate distantFuture]];
    isOver = YES;
    if (blockOnBeatOver) {
        blockOnBeatOver(self);
    }
    
}

- (void)beatsRestart {
    BabyLog(@">>>beatsRestart :%@",[NSDate date]);
    isOver = NO;
    [self beats];
}

- (void)setBlockOnBeatsBreak:(void(^)(BabyRhythm *bry))block {
    blockOnBeatBreak = block;
}

- (void)setBlockOnBeatsOver:(void(^)(BabyRhythm *bry))block {
    blockOnBeatOver = block;
}

@end
