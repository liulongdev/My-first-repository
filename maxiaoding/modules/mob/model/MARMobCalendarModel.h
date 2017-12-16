//
//  MARMobCalendarModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARBaseDBModel.h"

/**
 万年历相关数据
 */
@interface MARMobCalendarModel : MARBaseDBModel

@property (nonatomic, strong) NSString *date;       // 日期
@property (nonatomic, strong) NSString *lunar;      // 农历日期
@property (nonatomic, strong) NSString *lunarYear;  // 农历年
@property (nonatomic, strong) NSString *zodiac;     // 生肖
@property (nonatomic, strong) NSString *weekday;    // 星期几
@property (nonatomic, strong) NSString *suit;       // 宜
@property (nonatomic, strong) NSString *avoid;      // 不宜/忌
@property (nonatomic, strong) NSString *holiday;    // 节假日(不是节假日的日期数据为空)

@end
