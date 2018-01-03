//
//  MARUtility.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARGlobalModel.h"
#define MARUTILITY [MARUtility sharedInstance]
@interface MARUtility : NSObject

+ (instancetype) sharedInstance;

+ (BOOL)isLogin;

+ (BOOL)isBindPhone;

- (BOOL)isLogin;

- (BOOL)isBindPhone;

@property (nonatomic, strong) NSTimer *quickLoginPhoneCodeTimer;

@property (nonatomic, strong) NSTimer *setPasswordPhoneCodeTimer;

@property (nonatomic, strong) NSTimer *bindPhoneCodeTimer;

- (void)setPhoneCodeTimerWithType:(MARPhoneOperationType)operationType phone:(NSString *)phone;

@end
