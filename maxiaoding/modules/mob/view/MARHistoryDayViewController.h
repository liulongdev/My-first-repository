//
//  MARHistoryDayViewController.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"

@interface MARHistoryDayViewController : MARBaseViewController

@property (nonatomic, strong) NSDate *date;     // 查询历史的日期
@property (nonatomic, strong) NSString *dateStr;    // 查询历史日期的字符串  MMdd   格式

@end
