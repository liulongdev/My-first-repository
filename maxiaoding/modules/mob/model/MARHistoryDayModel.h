//
//  MARHistoryTodayModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARBaseDBModel.h"
@interface MARHistoryDayModel : MARBaseDBModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *title;

+ (NSArray<MARHistoryDayModel *> *)getHistoryDayArrayWithDateStr:(NSString *)dateStr;   // MMdd


/**
 return date with format yyyy-MM-dd

 @return date with format yyyy-MM-dd
 */
- (NSString *)getDateStr;

@end

/*
retCode    string    返回码
msg    string    返回说明
result    string    返回结果集
date    string    日期
month    string    月份
day    string    天
title    int    标题
event    int    事件
*/
