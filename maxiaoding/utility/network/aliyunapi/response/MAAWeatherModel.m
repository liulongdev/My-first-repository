//
//  MAAWhtetherModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/31.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAAWeatherModel.h"

@implementation MAAWeatherModel

//+(void)initialize
//{
//    [self setTableColumnName:@"myindex" bindingPropertyName:@"index"];
//}

+ (NSDictionary<NSString *,id> *)mar_modelCustomPropertyMapper
{
    return @{@"myindex": @"index"};
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"cityid"];
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"index": [MAAWeatherLifeIndexM class],
             @"aqi": [MAAWeatherAQIM class],
             @"daily": [MAAWeatherDayInfoM class],
             @"hourly": [MAAWeatherHourInfoM class],
             };
}

+ (MAAWeatherModel *)weatherModelWithCityId:(NSString *)cityId
{
    NSArray *weatherArray = [[self getUsingLKDBHelper] search:[self class] where:@{@"cityid": cityId} orderBy:nil offset:0 count:0];
    if (weatherArray && weatherArray.count > 0) {
        return weatherArray[0];
    }
    return nil;
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

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[self class]]) {
        __typeof(self) other = object;
        return [self.cityid isEqual:other.cityid];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.cityid hash];
}

+ (NSArray<MAAWeatherCityModel *> *)cityArrayWithParentId:(NSString *)parentId
{
    NSArray *cityArray = [[self getUsingLKDBHelper] search:[self class] where:@{@"parentId": parentId} orderBy:nil offset:0 count:0];
    return cityArray;
}

+ (NSArray<MAAWeatherCityModel *> *)cityArrayWhere:(id)where
{
    NSArray *cityArray = [[self getUsingLKDBHelper] search:[self class] where:where orderBy:nil offset:0 count:0];
    return cityArray;
}

+ (NSArray<MAAWeatherCityModel *> *)cityArrayWithLikeKey:(NSString *)key
{
    
    NSString *sqlStr = @"";
//    if ([key mar_matchWithRegex:@"\\d+"].count > 0) {
//        sqlStr = [NSString stringWithFormat:@"citycode like '%%%@%%'",  key];
//    }
//    else
//    {
//        sqlStr = [NSString stringWithFormat:@"city like '%%%@%%'", key];
//    }
    sqlStr = [NSString stringWithFormat:@"city like '%%%@%%' and parentid != '0' or city in ('北京','上海','重庆','天津','北京市','上海市','重庆市','天津市')", key];
    NSArray<MAAWeatherCityModel *> *cityArray = [[self.class getUsingLKDBHelper] search:[self class] where:sqlStr orderBy:nil offset:0 count:0];
    return cityArray;
}

@end

@implementation MAAWeatherLocalCityModel

+ (instancetype)localCityMWithWeatherCityM:(MAAWeatherCityModel *)model
{
    MAAWeatherLocalCityModel *localCityM = [MAAWeatherLocalCityModel mar_modelWithJSON:[model mar_modelToJSONObject]];
    return localCityM;
}

@end
