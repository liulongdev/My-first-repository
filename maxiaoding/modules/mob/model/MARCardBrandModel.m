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

@implementation MARCardSerieModel

+ (NSString *)getPrimaryKey
{
    return @"carId";
}

+ (NSArray<MARCardSerieModel *> *)getCardSerieArrayWithBrandName:(NSString *)brandName
{
    NSDictionary *sqlDic = @{@"brandName":brandName};
    NSArray<MARCardSerieModel *> *cardSerieArray = [[self.class getUsingLKDBHelper] search:[self class] where:sqlDic orderBy:nil offset:0 count:0];
    return cardSerieArray;
}

@end

@implementation MARCardDetailModel

+ (NSString *)getPrimaryKey
{
    return @"carId";
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"baseInfo":       [MARCardNameValueModel class],
             @"airConfig":      [MARCardNameValueModel class],
             @"carbody":        [MARCardNameValueModel class],
             @"chassis":        [MARCardNameValueModel class],
             @"controlConfig":  [MARCardNameValueModel class],
             @"engine":         [MARCardNameValueModel class],
             @"exterConfig":    [MARCardNameValueModel class],
             @"glassConfig":    [MARCardNameValueModel class],
             @"interConfig":    [MARCardNameValueModel class],
             @"lightConfig":    [MARCardNameValueModel class],
             @"mediaConfig":    [MARCardNameValueModel class],
             @"safetyDevice":   [MARCardNameValueModel class],
             @"seatConfig":     [MARCardNameValueModel class],
             @"techConfig":     [MARCardNameValueModel class],
             @"transmission":   [MARCardNameValueModel class],
             @"wheelInfo":      [MARCardNameValueModel class],
             @"motorList":      [MARCardNameValueModel class]
             };
}

@end

@implementation MARCardNameValueModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

@end
