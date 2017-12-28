//
//  MARSMS.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/27.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MARSMS : NSObject


/**
 @param phoneNumber 电话号码(The phone number)
 @param result 请求结果回调(Results of the request)
 */
+ (void)getPhoneCodeWithPhone:(NSString *)phoneNumber
                       result:(void (^)(NSError *err))result;


/**
 @param code 验证码(Verification code)
 @param phoneNumber 电话号码(The phone number)
 @param result 请求结果回调(Results of the request)
 */
+ (void)checkVerifyCode:(NSString *)code
            phoneNumber:(NSString *)phoneNumber
                 result:(void (^)(NSError *err))result;

@end
