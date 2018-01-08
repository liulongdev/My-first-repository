//
//  MARWYNewModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewModel.h"

@implementation MARWYNewModel

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

@end

@implementation MARWYVideoCategoryTitleModel

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARWYVideoCategoryTitleModel class]]) {
        MARWYVideoCategoryTitleModel *model = object;
        return [self.cname isEqual:model.cname];
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

- (NSUInteger)hash
{
    return [self.cname hash] * 17 + [self.ename hash];
}

@end

@implementation MARWYPhotoNewModel



@end

@implementation MARWYVideoNewModel

@end

@implementation MARWYTouTiaoNewModel

@end
