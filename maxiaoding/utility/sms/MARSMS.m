//
//  MARSMS.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/27.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARSMS.h"
#import <SMS_SDK/SMSSDK.h>
@implementation MARSMS

+ (void)getPhoneCodeWithPhone:(NSString *)phoneNumber
                       result:(void (^)(NSError *))result
{
    NSError *error = nil;
    if (![phoneNumber isKindOfClass:[NSString class]] || phoneNumber.length <= 0) {
//        ShowErrorMessage(@"手机号码不能为空哦", 1.f);
        error = [NSError errorWithDomain:@"NSNullErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:@"手机号码不能为空哦"}];
        if (result) {
            result(error);
        }
        return;
    }
    else if (![phoneNumber mar_isMobileNumber]) {
//        ShowErrorMessage(@"手机格式不正确或者不支持该号码", 1.f);
        error = [NSError errorWithDomain:@"NSNullErrorDomain" code:300002 userInfo:@{NSLocalizedDescriptionKey:@"手机格式不正确或者不支持该号码"}];
        if (result) {
            result(error);
        }
        return;
    }
    else
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber zone:@"86" result:result];
}

+ (void)checkVerifyCode:(NSString *)code
            phoneNumber:(NSString *)phoneNumber
                 result:(void (^)(NSError *))result
{
    NSError *error = nil;
    if (![phoneNumber isKindOfClass:[NSString class]] || phoneNumber.length <= 0) {
        //        ShowErrorMessage(@"手机号码不能为空哦", 1.f);
        error = [NSError errorWithDomain:@"NSNullErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:@"手机号码不能为空哦"}];
        if (result) {
            result(error);
        }
        return;
    }
    else if (![phoneNumber mar_isMobileNumber]) {
        //        ShowErrorMessage(@"手机格式不正确或者不支持该号码", 1.f);
        error = [NSError errorWithDomain:@"NSNullErrorDomain" code:300002 userInfo:@{NSLocalizedDescriptionKey:@"手机格式不正确或者不支持该号码"}];
        if (result) {
            result(error);
        }
        return;
    }
    else
        [SMSSDK commitVerificationCode:code phoneNumber:phoneNumber zone:@"86" result:result];
}

@end
