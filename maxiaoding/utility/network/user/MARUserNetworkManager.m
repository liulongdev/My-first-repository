//
//  MARUserNetworkManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/31.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARUserNetworkManager.h"

@implementation MARUserNetworkManager

+ (void)thirdPlatformLogin:(MARThirdPlatFormLoginR *)param
                   success:(MARNetworkSuccess)success
                   failure:(MARNetworkFailure)failure
{
    MARBaseRequest *baseR = [MARBaseRequest new];
    baseR.userId = @"";
    MARNetworkManager *netWorkManager = [MARNetworkManager new];
    [netWorkManager.requestSerializer setValue:[baseR mar_modelToJSONString] forHTTPHeaderField:@"mar-signature"];
    [netWorkManager mar_post:SERVERAPI_ThirdPlatformLogin parameters:param success:success failure:failure];

//    param.userId = @"";
//    [MARNetworkManager mar_post:SERVERAPI_ThirdPlatformLogin parameters:param success:success failure:failure];
}

+ (void)quickLoginWithPhone:(MARQuickLoginWithPhoneR *)param
                    success:(MARNetworkSuccess)success
                    failure:(MARNetworkFailure)failure
{
    MARBaseRequest *baseR = [MARBaseRequest new];
    baseR.userId = @"";
    MARNetworkManager *netWorkManager = [MARNetworkManager new];
    [netWorkManager.requestSerializer setValue:[baseR mar_modelToJSONString] forHTTPHeaderField:@"mar-signature"];
    [netWorkManager mar_post:SERVERAPI_QuickLoginWithPhone parameters:param success:success failure:failure];
    
//    param.userId = @"";
//    [MARUserNetworkManager mar_post:SERVERAPI_QuickLoginWithPhone parameters:param success:success failure:failure];
}

+ (void)userExistWithPhone:(MARUserExistWithPhoneR *)param
                   success:(MARNetworkSuccess)success
                   failure:(MARNetworkFailure)failure
{
    [MARUserNetworkManager mar_get:SERVERAPI_UserExistWithPhone parameters:param success:success failure:failure];
}

+ (void)setPassword:(MARSetPasswordR *)param
            success:(MARNetworkSuccess)success
            failure:(MARNetworkFailure)failure
{
    [MARUserNetworkManager mar_post:SERVERAPI_SetPassword parameters:param success:success failure:failure];
}

+ (void)loginWithPhone:(MARLoginWithPhoneR *)param
               success:(MARNetworkSuccess)success
               failure:(MARNetworkFailure)failure
{
    MARBaseRequest *baseR = [MARBaseRequest new];
    baseR.userId = @"";
    MARNetworkManager *netWorkManager = [MARNetworkManager new];
    [netWorkManager.requestSerializer setValue:[baseR mar_modelToJSONString] forHTTPHeaderField:@"mar-signature"];
    [netWorkManager mar_get:SERVERAPI_LoginWithPhone parameters:param success:success failure:failure];
    
//    param.userId = @"";
//    [MARUserNetworkManager mar_get:SERVERAPI_LoginWithPhone parameters:param success:success failure:failure];
}

+ (void)bindPhone:(MARBindPhoneR *)param
          success:(MARNetworkSuccess)success
          failure:(MARNetworkFailure)failure
{
    [MARNetworkManager mar_post:SERVERAPI_BindPhone parameters:param success:success failure:failure];
}

@end
