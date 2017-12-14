//
//  MARCardBrandModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCardBrandModel.h"

@implementation MARCardBrandModel

+ (NSString *)getPrimaryKey
{
    return @"name";
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"son": [MARCarTypeInfoModel class]};
}

- (NSString *)description
{
    return [self mar_modelDescription];
}

@end

@implementation MARCarTypeInfoModel

+ (NSString *)getPrimaryKey
{
    return @"type";
}

- (NSString *)description
{
    return [self mar_modelDescription];
}

@end

@implementation MARCarSerieInfoModel

@end
