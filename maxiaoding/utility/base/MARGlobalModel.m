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
@property (nonatomic, strong) NSString *globalId;
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

- (BOOL)isLogin
{
    return [self.userInfo._id isKindOfClass:[NSString class]] && self.userInfo._id.length > 0;
}

- (BOOL)isBindPhone
{
    return [self.userInfo.phone mar_isMobileNumber];
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

- (NSString *)description
{
    return [self mar_modelDescription];
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

@implementation MARStyleFormat

+ (instancetype)sharedInstance
{
    MARSINGLE_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    })
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self mar_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mar_modelEncodeWithCoder:aCoder];
}

- (NSDictionary *)biaoTiAttrDic
{
    if (!_biaoTiAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _biaoTiAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(20.f), NSForegroundColorAttributeName : RGBHEX(0x333333)};
    }
    return _biaoTiAttrDic;
}

- (NSDictionary *)ziBiaoTiAttrDic
{
    if (!_ziBiaoTiAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _ziBiaoTiAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(16.f), NSForegroundColorAttributeName : RGBHEX(0x333333)};
    }
    return _ziBiaoTiAttrDic;
}

- (NSDictionary *)zhengWenAttrDic
{
    if (!_zhengWenAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.alignment = NSTextAlignmentLeft;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _zhengWenAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(14.f), NSForegroundColorAttributeName : RGBHEX(0x666666)};
    }
    return _zhengWenAttrDic;
}

- (NSDictionary *)shuoMingAttrDic
{
    if (!_shuoMingAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _shuoMingAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(14.f), NSForegroundColorAttributeName : RGBHEX(0x999999)};
    }
    return _shuoMingAttrDic;
}

- (NSDictionary *)tuPianJieShaoAttrDic
{
    if (!_tuPianJieShaoAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _tuPianJieShaoAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(12.f), NSForegroundColorAttributeName : RGBHEX(0x999999)};
    }
    return _tuPianJieShaoAttrDic;
}

- (NSDictionary *)shuoMingCenterAttrDic
{
    if (!_shuoMingCenterAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _shuoMingCenterAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(14.f), NSForegroundColorAttributeName : RGBHEX(0x666666)};
    }
    return _shuoMingCenterAttrDic;
}

- (NSDictionary *)carSimpleInfoAttrDic
{
    if (!_carSimpleInfoAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3;
        style.alignment = NSTextAlignmentLeft;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _carSimpleInfoAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : MAREXTFont(12.f), NSForegroundColorAttributeName : RGBHEX(0x666666)};
    }
    return _carSimpleInfoAttrDic;
}

@end

