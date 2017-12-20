//
//  MARMobCalendarModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobCalendarModel.h"

@implementation MARMobCalendarModel

+ (NSString *)getPrimaryKey
{
    return @"date";
}

- (NSString *)description
{
    return [self mar_modelDescription];
}

@end
