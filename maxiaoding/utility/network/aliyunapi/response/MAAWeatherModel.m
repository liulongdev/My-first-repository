//
//  MAAWhtetherModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/31.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAAWeatherModel.h"

@implementation MAAWeatherModel

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"index": [MAAWeatherLifeIndexM class],
             @"aqi": [MAAWeatherAQIM class],
             @"daily": [MAAWeatherDayInfoM class],
             @"hourly": [MAAWeatherHourInfoM class],
             };
}

@end

// 生活指数
@implementation MAAWeatherLifeIndexM

+(NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"aqiinfo": [MAAWeatherAQIInfoM class]};
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

@end

// 空气质量指数
@implementation MAAWeatherAQIM

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

@end

@implementation MAAWeatherAQIInfoM

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

@end

@implementation MAAWeatherDayInfoM

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"day": [MAAWeatherDayM class],
             @"night": [MAAWeatherNigthM class]
             };
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

@end

@implementation MAAWeatherDayM

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

@end

@implementation MAAWeatherNigthM

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

@end

@implementation MAAWeatherHourInfoM
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}
@end

@implementation MAAWeatherCityModel

+ (NSString *)getPrimaryKey
{
    return @"cityid";
}

@end
