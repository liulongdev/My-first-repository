//
//  MARLaohuangliModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseDBModel.h"


/**
 老黄历相关数据
 */
@interface MARLaohuangliModel : MARBaseDBModel

@property (nonatomic, strong) NSString *date;       // 查询日期
@property (nonatomic, strong) NSString *lunar;      // 农历日期
@property (nonatomic, strong) NSString *suit;       // 宜
@property (nonatomic, strong) NSString *avoid;      // 不宜/忌
@property (nonatomic, strong) NSString *jishen;     // 吉煞
@property (nonatomic, strong) NSString *xiongshen;  // 凶煞

@end
