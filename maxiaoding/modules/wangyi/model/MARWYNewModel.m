//
//  MARWYNewModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewModel.h"

@implementation MARWYNewModel

+ (NSString *)getPrimaryKey
{
    return @"tid";
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARWYNewModel class]]) {
        MARWYNewModel *model = object;
        return [self.tid isEqual:model.tid];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.tid hash];
}

@end


@implementation MARWYNewCategoryTitleModel

+ (NSString *)getPrimaryKey
{
    return @"tid";
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARWYNewCategoryTitleModel class]]) {
        MARWYNewCategoryTitleModel *model = object;
        return [self.tid isEqual:model.tid];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.tid hash] * 17 + [self.tname hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

+ (NSArray *)getArrayFavorite:(BOOL)isFavorite
{
    NSString *sql = @"notAttention != 1";
    if (!isFavorite) {
        sql = @"notAttention == 1";
    }
    NSArray *array = [[self getUsingLKDBHelper] search:[self class] where:sql orderBy:@"orderNumber asc" offset:0 count:0];
    return array;
}

@end

@implementation MARWYVideoCategoryTitleModel

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARWYVideoCategoryTitleModel class]]) {
        MARWYVideoCategoryTitleModel *model = object;
        return [self.cname isEqual:model.cname] && [self.ename isEqual:model.ename];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.cname hash] * 17 + [self.ename hash];
}

@end

@implementation MARWYPhotoNewModel

+ (NSString *)getPrimaryKey
{
    return @"autoid";
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARWYPhotoNewModel class]]) {
        MARWYPhotoNewModel *model = object;
        return [self.autoid isEqual:model.autoid];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.autoid hash];
}

@end

@implementation MARWYVideoNewModel
+ (NSString *)getPrimaryKey
{
    return @"vid";
}

+ (NSDictionary<NSString *,id> *)mar_modelCustomPropertyMapper
{
    return @{@"videoTopic": [MARWYVideoTopicModel class]};
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARWYVideoNewModel class]]) {
        MARWYVideoNewModel *model = object;
        return [self.vid isEqual:model.vid];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.vid hash];
}

@end

@implementation MARWYVideoTopicModel
+ (NSString *)getPrimaryKey
{
    return @"tid";
}
@end

@implementation MARWYTouTiaoNewModel

@end
