//
//  MARTianxingUtil.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARTianxingUtil.h"

@interface MARTianxingUtil()

@property (nonatomic, strong) NSDictionary *txNewsUrlDic;

@end

@implementation MARTianxingUtil

+ (instancetype)sharedInstance
{
    MARSINGLE_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (NSDictionary *)txNewsUrlDic
{
    if (!_txNewsUrlDic) {
        _txNewsUrlDic = @{
                          MARSTRWITHINT(TXNEWSType_SheHui): @"http://api.tianapi.com/social/",
                          MARSTRWITHINT(TXNEWSType_GuoNei): @"http://api.tianapi.com/guonei/",
                          MARSTRWITHINT(TXNEWSType_GuoJi): @"http://api.tianapi.com/world/",
                          MARSTRWITHINT(TXNEWSType_YuLe): @"http://api.tianapi.com/huabian/",
                          MARSTRWITHINT(TXNEWSType_TiYu): @"http://api.tianapi.com/tiyu/",
                          MARSTRWITHINT(TXNEWSType_NBA): @"http://api.tianapi.com/nba/",
                          MARSTRWITHINT(TXNEWSType_ZuQiu): @"http://api.tianapi.com/football/",
                          MARSTRWITHINT(TXNEWSType_KeJi): @"http://api.tianapi.com/keji/?",
                          MARSTRWITHINT(TXNEWSType_ChuangYe): @"http://api.tianapi.com/startup/",
                          MARSTRWITHINT(TXNEWSType_PingGuo): @"http://api.tianapi.com/apple/",
                          MARSTRWITHINT(TXNEWSType_JunShi): @"http://api.tianapi.com/military/",
                          MARSTRWITHINT(TXNEWSType_YiDongHuLian): @"http://api.tianapi.com/mobile/",
                          MARSTRWITHINT(TXNEWSType_LvYouZiXun): @"http://api.tianapi.com/travel/",
                          MARSTRWITHINT(TXNEWSType_QuWenYiShi): @"http://api.tianapi.com/qiwen/",
                          MARSTRWITHINT(TXNEWSType_JianKangZhiShi): @"http://api.tianapi.com/health/",
                          MARSTRWITHINT(TXNEWSType_MeiNvTuPian): @"http://api.tianapi.com/meinv/",
                          MARSTRWITHINT(TXNEWSType_VRKeJi): @"http://api.tianapi.com/vr/",
                          MARSTRWITHINT(TXNEWSType_ITZiXun): @"http://api.tianapi.com/it/",
                          };
    }
    return _txNewsUrlDic;
}

- (NSString *)urlWithNewsType:(MARTXNEWSType)txNewType
{
    return self.txNewsUrlDic[MARSTRWITHINT(txNewType)] ?: @"";
}

+ (NSString *)urlWithNewsType:(MARTXNEWSType)txNewType
{
    return [[self sharedInstance] urlWithNewsType:txNewType];
}

@end
