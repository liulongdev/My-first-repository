//
//  MARCookCategoryModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookCategoryModel.h"

@implementation MARCookCategoryModel

- (id)copyWithZone:(NSZone *)zone
{
    return [self mar_modelCopy];
}

+ (NSString *)getPrimaryKey
{
    return @"ctgId";
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARCookCategoryModel class]]) {
        MARCookCategoryModel *other = object;
        return [self.ctgId isEqual:other.ctgId];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.ctgId hash];
}

@end

@implementation MARCookCategoryMenuModel

// 重载    返回自己处理过的 要插入数据库的值
- (id)userGetValueForModel:(LKDBProperty *)property
{
    if([property.sqlColumnName isEqualToString:@"childs"])
    {
        if (self.childs == nil || self.childs.count == 0) return @"";
        for (MARCookCategoryModel *model in self.childs) {
            [model updateToDB];
        }
//        return self.childs[0].parentId;
        return self.ctgId;
    }
    return nil;
}

// 重载    返回自己处理过的 要插入数据库的值
- (void)userSetValueForModel:(LKDBProperty *)property value:(id)value
{
    if([property.sqlColumnName isEqualToString:@"childs"])
    {
        self.childs = nil;
        
        NSDictionary *sqlWhereDic = @{@"parentId":value ?: (self.ctgId ?: @"-10000")};
        NSArray<MARCookCategoryModel *> *array  = [MARCookCategoryModel searchSingleWithWhere:sqlWhereDic orderBy:@"ctgId asc"];
        self.childs = array;
    }
}

+ (NSString *)getPrimaryKey
{
    return @"ctgId";
}

@end

@implementation MARCookDetailModel

+ (NSString *)getPrimaryKey
{
    return @"menuId";
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"recipe": [MARCookRecipe class]};
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[MARCookDetailModel class]]) {
        MARCookDetailModel *other = object;
        return [self.menuId isEqual:other.menuId];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.menuId hash];
}

@end

@implementation MARCookRecipe

+ (void)initialize
{
    //  移除掉表中不要的属性
    [self removePropertyWithColumnName:@"wrapperMethods"];
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"method": [MARCookStep class]};
}

- (NSArray<MARCookStep *> *)wrapperMethods
{
    return self.method;
//    if (!_wrapperMethods || ![_wrapperMethods isKindOfClass:[NSArray class]] || _wrapperMethods.count <= 0) {
//        _wrapperMethods = [NSArray mar_modelArrayWithClass:[MARCookStep class] json:self.method];
//    }
//    return _wrapperMethods;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    return [self mar_modelEncodeWithCoder:aCoder];
}

@end

@implementation MARCookStep

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    return [self mar_modelEncodeWithCoder:aCoder];
}

@end
