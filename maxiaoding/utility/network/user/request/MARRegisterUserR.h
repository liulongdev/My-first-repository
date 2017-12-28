//
//  MARRegisterUserR.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/28.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseRequest.h"

@interface MARRegisterUserR : MARBaseRequest
@property (nonatomic, strong) NSString *iphone;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@end
