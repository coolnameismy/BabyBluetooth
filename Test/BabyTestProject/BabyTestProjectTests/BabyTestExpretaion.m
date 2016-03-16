//
//  BabyTestExpretaion.m
//  BabyTestProject
//
//  Created by 刘彦玮 on 16/3/14.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import "BabyTestExpretaion.h"

@interface BabyTestExpretaion()


@property (nonatomic, strong) XCTestExpectation *exp;

@end

@implementation BabyTestExpretaion

- (instancetype)initWithExp:(XCTestExpectation *)exp {
  self = [super init];
  if (self) {
    _exp = exp;
    _hasFulfill = NO;
  }
  return self;
}

- (void)fulfill {
  if (!self.hasFulfill) {
    [self.exp fulfill];
  }
  self.hasFulfill = YES;
}
@end
