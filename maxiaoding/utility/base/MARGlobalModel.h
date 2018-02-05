//
//  MARGlobalModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#define MARGLOBALMODEL [MARGlobalModel sharedInstance]

#import "MARBaseDBModel.h"

@interface MARUserInfoModel : MARBaseDBModel <NSCoding>
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *userImageIcon;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSDate *birthDay;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger state;

@end

@interface MARHomeConfigModel : MARBaseDBModel <NSCoding>

@end

#define MARSTYLEFORMAT [MARStyleFormat sharedInstance]
@interface MARStyleFormat : MARBaseDBModel <NSCoding>

+ (instancetype) sharedInstance;

@property (nonatomic, strong) NSDictionary *biaoTiAttrDic;

@property (nonatomic, strong) NSDictionary *ziBiaoTiAttrDic;

@property (nonatomic, strong) NSDictionary *zhengWenAttrDic;

@property (nonatomic, strong) NSDictionary *shuoMingAttrDic;

@property (nonatomic, strong) NSDictionary *shuoMingCenterAttrDic;

@property (nonatomic, strong) NSDictionary *tuPianJieShaoAttrDic;

@property (nonatomic, strong) NSDictionary *carSimpleInfoAttrDic;

@end

typedef NS_ENUM(NSInteger,  MARPhoneOperationType) {
    MARPhoneOperationTypeQuickLogin = 1,
    MARPhoneOperationTypeBind,
    MARPhoneOperationTypeSetPassword
};

@interface MARGlobalModel : MARBaseDBModel<NSCoding>

+ (instancetype) sharedInstance;

- (BOOL)isLogin;

- (BOOL)isBindPhone;

@property (nonatomic, strong) MARUserInfoModel *userInfo;

@property (nonatomic, strong) MARHomeConfigModel *homeConfig;

@end
