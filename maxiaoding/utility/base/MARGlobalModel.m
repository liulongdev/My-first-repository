//
//  MARGlobalModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARGlobalModel.h"

NSString * const MARGLobalModelId = @"10000";

@interface MARGlobalModel()
@property (nonatomic, strong, readonly) NSString *globalId;
@end

@implementation MARGlobalModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

+ (NSString *)getPrimaryKey
{
    return @"globalId";
}

+ (instancetype)sharedInstance
{
    static MARGlobalModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *globalModelArray = [MARGlobalModel searchWithWhere:@{@"globalId": MARGLobalModelId}];
        if (globalModelArray.count > 0) {
            instance = globalModelArray[0];
        }
        else
        {
            instance = [[MARGlobalModel alloc] init];
            instance->_globalId = MARGLobalModelId;
            [instance updateToDB];
        }
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    return self;
}

@end

@implementation MARUserInfoModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

@end

@implementation MARHomeConfigModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

@end

