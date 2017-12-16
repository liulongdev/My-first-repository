//
//  MARGlobalModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseDBModel.h"

@interface MARUserInfoModel : MARBaseDBModel <NSCoding>

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

@property (nonatomic, strong) NSDictionary * tuPianJieShaoAttrDic;

@end

@interface MARGlobalModel : MARBaseDBModel<NSCoding>

+ (instancetype) sharedInstance;

@property (nonatomic, strong) MARUserInfoModel *userInfo;

@property (nonatomic, strong) MARHomeConfigModel *homeConfig;

@end
