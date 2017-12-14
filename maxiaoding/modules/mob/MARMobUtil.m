//
//  MARMobUtil.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobUtil.h"

@implementation MARMobUtil

+ (instancetype)sharedInstance
{
    MARSINGLE_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (NSDictionary *)mobErrorDic
{
    if (!_mobErrorDic) {
        NSString *mobErrorPlistPath = [[NSBundle mainBundle] pathForResource:@"mob_error" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:mobErrorPlistPath];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            _mobErrorDic = dic;
        }
    }
    return _mobErrorDic;
}

@end
