//
//  requesturl.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/31.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#ifndef requesturl_h
#define requesturl_h

#define URLAppend(_host_, _serviceurl_)     [[NSURL URLWithString:_serviceurl_ relativeToURL:[NSURL URLWithString:_host_]] absoluteString]

#define SERVERHOST @"http://192.168.31.166:3000"


#define SHORTAPI_ThirdPlatformLogin         @"api/core/v1/user/thirdPlatformLogin"  // 第三方平台登陆
#define SHORTAPI_RegisterUser               @"api/core/v1/user/register"           // 注册用户
#define SHORTAPI_LoginWithPhone             @"api/core/v1/user/loginWithPhone"      // 手机登录
#define SHORTAPI_QuickLoginWithPhone        @"api/core/v1/user/quickLoginWithPhone" // 手机快速登录
#define SHORTAPI_ChangePassword             @"api/core/v1/user/changePassword"      // 更改密码
#define SHORTAPI_SetPassword                @"api/core/v1/user/setPassword"         // 设置密码
#define SHORTAPI_UserExistWithPhone         @"/api/core/v1/user/userExistWithPhone" // 是否存在该手机号的用户



#define SERVERAPI_ThirdPlatformLogin        URLAppend(SERVERHOST, SHORTAPI_ThirdPlatformLogin)
#define SERVERAPI_RegisterUser              URLAppend(SERVERHOST, SHORTAPI_RegisterUser)
#define SERVERAPI_LoginWithPhone            URLAppend(SERVERHOST, SHORTAPI_LoginWithPhone)
#define SERVERAPI_QuickLoginWithPhone       URLAppend(SERVERHOST, SHORTAPI_QuickLoginWithPhone)
#define SERVERAPI_ChangePassword            URLAppend(SERVERHOST, SHORTAPI_ChangePassword)
#define SERVERAPI_SetPassword               URLAppend(SERVERHOST, SHORTAPI_SetPassword)
#define SERVERAPI_UserExistWithPhone        URLAppend(SERVERHOST, SHORTAPI_UserExistWithPhone)
#define SERVERAPI_SetPassword               URLAppend(SERVERHOST, SHORTAPI_SetPassword)


#endif /* requesturl_h */
