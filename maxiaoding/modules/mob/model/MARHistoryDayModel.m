//
//  MARHistoryTodayModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHistoryDayModel.h"

@implementation MARHistoryDayModel

+ (NSString *)getPrimaryKey
{
    return @"id";
}

- (NSString *)getDateStr
{
    if ([self.date isKindOfClass:[NSString class]] && self.date.length == 8) {
        NSMutableString *myDateStr = [NSMutableString stringWithString:self.date];
        [myDateStr insertString:@"-" atIndex:6];
        [myDateStr insertString:@"-" atIndex:4];
        return myDateStr;
    }
    return self.date;
}

+ (NSArray<MARHistoryDayModel *> *)getHistoryDayArrayWithDateStr:(NSString *)dateStr
{
    BOOL isDescSort = [MARUserDefault getBoolBy:USERDEFAULTKEY_HistoryDayDataDESCSort];
    NSString *orderStr = [NSString stringWithFormat:@"date %@", (isDescSort ? @"desc" : @"asc")];
    NSString *sqlStr = [NSString stringWithFormat:@"date like '%%%@'", dateStr];
    NSArray<MARHistoryDayModel *> *historyDayArray = [[self.class getUsingLKDBHelper] search:[self class] where:sqlStr orderBy:orderStr offset:0 count:0];
    return historyDayArray;
}

@end
