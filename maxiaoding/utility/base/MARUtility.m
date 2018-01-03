//
//  MARUtility.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARUtility.h"

@implementation MARUtility

+ (instancetype)sharedInstance
{
    static MARUtility *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MARUtility alloc] init];
    });
    return instance;
}

- (BOOL)isLogin
{
    return [MARGLOBALMODEL.userInfo._id isKindOfClass:[NSString class]] && MARGLOBALMODEL.userInfo._id.length > 0;
}

- (BOOL)isBindPhone
{
    return [MARGLOBALMODEL.userInfo.phone mar_isMobileNumber];
}

+ (BOOL)isLogin
{
    return [[self sharedInstance] isLogin];
}

+ (BOOL)isBindPhone
{
    return [[self sharedInstance] isBindPhone];
}

- (void)setPhoneCodeTimerWithType:(MARPhoneOperationType)operationType phone:(NSString *)phone
{
    switch (operationType) {
        case MARPhoneOperationTypeQuickLogin:
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone?:@"", @"count": @(60), @"operationType": @(operationType)}];
            [_quickLoginPhoneCodeTimer invalidate];
            _quickLoginPhoneCodeTimer = nil;
            _quickLoginPhoneCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:[MARWeakProxy proxyWithTarget:self] selector:@selector(phoneCodeCountDown:) userInfo:userInfo repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_quickLoginPhoneCodeTimer forMode:NSRunLoopCommonModes];
        }
            break;
        case MARPhoneOperationTypeBind:
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone?:@"", @"count": @(60), @"operationType": @(operationType)}];
            [_bindPhoneCodeTimer invalidate];
            _bindPhoneCodeTimer = nil;
            _bindPhoneCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:[MARWeakProxy proxyWithTarget:self] selector:@selector(phoneCodeCountDown:) userInfo:userInfo repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_bindPhoneCodeTimer forMode:NSRunLoopCommonModes];
        }
            break;
        case MARPhoneOperationTypeSetPassword:
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone?:@"", @"count": @(60), @"operationType": @(operationType)}];
            [_setPasswordPhoneCodeTimer invalidate];
            _setPasswordPhoneCodeTimer = nil;
            _setPasswordPhoneCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:[MARWeakProxy proxyWithTarget:self] selector:@selector(phoneCodeCountDown:) userInfo:userInfo repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_setPasswordPhoneCodeTimer forMode:NSRunLoopCommonModes];
        }
            break;
    }
}

- (void)phoneCodeCountDown:(NSTimer *)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    if ([userInfo[@"count"] integerValue] > 0) {
        userInfo[@"count"] = @([userInfo[@"count"] integerValue] - 1);
        [MARGLOBALMANAGER postNotif:kMARNotificationType_PhoneCodeCount data:userInfo object:nil];
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}

@end
