//
//  MARWYUtility.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/5.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYUtility.h"

@implementation MARWYUtility

+ (instancetype)sharedInstance
{
    static MARWYUtility *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MARWYUtility alloc] init];
    });
    return instance;
}

- (MARWYDataProxy *)dataProxy
{
    if (!_dataProxy) {
        _dataProxy = [MARWYDataProxy new];
    }
    return _dataProxy;
}

@end
