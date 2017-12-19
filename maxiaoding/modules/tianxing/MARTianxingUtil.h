//
//  MARTianxingUtil.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MARTXNEWSType) {
    TXNEWSType_SheHui,
    TXNEWSType_GuoNei,
    TXNEWSType_GuoJi,
    TXNEWSType_YuLe,
    TXNEWSType_TiYu,
    TXNEWSType_NBA,
    TXNEWSType_ZuQiu,
    TXNEWSType_KeJi,
    TXNEWSType_ChuangYe,
    TXNEWSType_PingGuo,
    TXNEWSType_JunShi,
    TXNEWSType_YiDongHuLian,
    TXNEWSType_LvYouZiXun,
    TXNEWSType_QuWenYiShi,
    TXNEWSType_JianKangZhiShi,
    TXNEWSType_MeiNvTuPian,
    TXNEWSType_VRKeJi,
    TXNEWSType_ITZiXun,
};

#define MARTIANXINGUTIL [MARTianxingUtil sharedInstance]
#import "tianxingmodel.h"
@interface MARTianxingUtil : NSObject

+ (instancetype)sharedInstance;

- (NSString *)urlWithNewsType:(MARTXNEWSType)txNewType;

+ (NSString *)urlWithNewsType:(MARTXNEWSType)txNewType;

@end
