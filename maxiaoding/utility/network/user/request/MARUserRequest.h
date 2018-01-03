//
//  MARUserRequest.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/31.
//  strongright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseRequest.h"
#import <UMSocialCore/UMSocialCore.h>
@interface MARUserRequest : MARBaseRequest

@end

@interface MARRegisterUserR : MARBaseRequest
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@end

@interface MARThirdPlatFormLoginR : MARBaseRequest
@property (nonatomic, strong) NSString  *usid;
@property (nonatomic, strong) NSString  *uid;
@property (nonatomic, strong) NSString  *openid;
@property (nonatomic, strong) NSString  *refreshToken;
@property (nonatomic, strong) NSDate    *expiration;
@property (nonatomic, strong) NSString  *accessToken;
@property (nonatomic, strong) NSString  *unionId;
@property (nonatomic, assign) UMSocialPlatformType  platformType;
@property (nonatomic, strong) id  originalResponse;

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *iconurl;
@property (nonatomic, strong) NSString  *unionGender;
@property (nonatomic, strong) NSString  *gender;
@end

@interface MARQuickLoginWithPhoneR : MARBaseRequest
@property (nonatomic, strong) NSString  *phone;
@end

@interface MARUserExistWithPhoneR : MARBaseRequest
@property (nonatomic, strong) NSString  *phone;
@end

@interface MARSetPasswordR : MARBaseRequest
@property (nonatomic, strong) NSString  *userId;
@property (nonatomic, strong) NSString  *password;
@end

@interface MARLoginWithPhoneR : MARBaseRequest
@property (nonatomic, strong) NSString  *phone;
@property (nonatomic, strong) NSString  *password;
@end

