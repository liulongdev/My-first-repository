//
//  MARUserNetworkManager.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/31.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARNetworkManager.h"
#import "request.h"

@interface MARUserNetworkManager : MARNetworkManager

+ (void)thirdPlatformLogin:(MARThirdPlatFormLoginR *)param
                   success:(MARNetworkSuccess)success
                   failure:(MARNetworkFailure)failure;

+ (void)quickLoginWithPhone:(MARQuickLoginWithPhoneR *)param
                    success:(MARNetworkSuccess)success
                    failure:(MARNetworkFailure)failure;

+ (void)userExistWithPhone:(MARUserExistWithPhoneR *)param
                   success:(MARNetworkSuccess)success
                   failure:(MARNetworkFailure)failure;

+ (void)setPassword:(MARSetPasswordR *)param
            success:(MARNetworkSuccess)success
            failure:(MARNetworkFailure)failure;

+ (void)loginWithPhone:(MARLoginWithPhoneR *)param
               success:(MARNetworkSuccess)success
               failure:(MARNetworkFailure)failure;

+ (void)bindPhone:(MARBindPhoneR *)param
          success:(MARNetworkSuccess)success
          failure:(MARNetworkFailure)failure;

@end
