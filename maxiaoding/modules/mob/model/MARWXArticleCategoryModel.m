//
//  MARWXArticleCategoryModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWXArticleCategoryModel.h"

@implementation MARWXArticleCategoryModel

+ (NSString *)getPrimaryKey
{
    return @"cid";
}

- (NSString *)description
{
    return [self mar_modelDescription];
}

@end
