//
//  BabyTestExpretaion.h
//  BabyTestProject
//
//  Created by 刘彦玮 on 16/3/14.
//  Copyright © 2016年 liuyanwei. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BabyTestExpretaion : NSObject


- (instancetype) initWithExp:(XCTestExpectation *)exp;

- (void) fulfill;

@end
