//
//  MARCarBrandModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCarBrandModel.h"

@implementation MARCarBrandModel

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (NSString *)description
{
    return [self mar_modelDescription];
}

@end

@implementation MARCarSerieInfoModel

@end

@implementation MARCarSerieModel

+ (NSString *)getPrimaryKey
{
    return @"carId";
}

+ (NSArray<MARCarSerieModel *> *)getCardSerieArrayWithBrandName:(NSString *)brandName
{
    NSDictionary *sqlDic = @{@"brandName":brandName};
    NSArray<MARCarSerieModel *> *cardSerieArray = [[self.class getUsingLKDBHelper] search:[self class] where:sqlDic orderBy:nil offset:0 count:0];
    return cardSerieArray;
}

@end

@implementation MARCarDetailModel

+ (NSString *)getPrimaryKey
{
    return @"carId";
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"baseInfo":       [MARCarNameValueModel class],
             @"airConfig":      [MARCarNameValueModel class],
             @"carbody":        [MARCarNameValueModel class],
             @"chassis":        [MARCarNameValueModel class],
             @"controlConfig":  [MARCarNameValueModel class],
             @"engine":         [MARCarNameValueModel class],
             @"exterConfig":    [MARCarNameValueModel class],
             @"glassConfig":    [MARCarNameValueModel class],
             @"interConfig":    [MARCarNameValueModel class],
             @"lightConfig":    [MARCarNameValueModel class],
             @"mediaConfig":    [MARCarNameValueModel class],
             @"safetyDevice":   [MARCarNameValueModel class],
             @"seatConfig":     [MARCarNameValueModel class],
             @"techConfig":     [MARCarNameValueModel class],
             @"transmission":   [MARCarNameValueModel class],
             @"wheelInfo":      [MARCarNameValueModel class],
             @"motorList":      [MARCarNameValueModel class]
             };
}

@end

@implementation MARCarNameValueModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

@end
