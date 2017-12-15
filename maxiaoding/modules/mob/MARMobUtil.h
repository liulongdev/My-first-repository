//
//  MARMobUtil.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "mobmodel.h"
#import <MobAPI/MobAPI.h>
#define MARMOBUTIL [MARMobUtil sharedInstance]

typedef void (^MobRequestCallBack)(MOBAResponse *response, id wrapperModel, NSString *errMsg);

@interface MARMobUtil : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSDictionary *mobErrorDic;

+ (NSDictionary *)mobErrorDic;


/**
 获取mob万年历数据

 @param dateStr 日期 yyyy-MM-dd
 @param callback 回调
 */
+ (void)loadCalendarWithDateStr:(NSString *)dateStr
                       callback:(void (^)(MOBAResponse *response, MARMobCalendarModel *calendarModel, NSString *errMsg))callback;


/**
 获取mob万年历数据

 @param date 日期 NSDate
 @param callback 回调
 */
+ (void)loadCalendarWithDate:(NSDate *)date
                    callback:(void (^)(MOBAResponse *response, MARMobCalendarModel *calendarModel, NSString *errMsg))callback;


/**
 查询所有汽车品牌

 @param callback 回调
 */
+ (void)loadCarBrandListCallback:(void (^)(MOBAResponse *response, NSArray<MARCarBrandModel *> *cardBrandArray, NSString *errMsg))callback;


/**
 根据车系名称查询车型

 @param name 车系名称(从所有汽车品牌接口中取)，必填项，不允许为 nil
 @param callback 回调
 */
+ (void)loadCarSeriesName:(NSString *)name
                 callback:(void (^)(MOBAResponse *response, NSArray<MARCarSerieModel *> *cardSerieArray, NSString *errMsg))callback;


/**
 查询车型详细信息

 @param cid 车型接口id(默认使用id查询)，必填项，不允许为 nil
 @param callback 回调
 */
+ (void)loadCarSeriesDetailWithCid:(NSString *)cid
                          callback:(void (^)(MOBAResponse *response, MARCarDetailModel *carDetail, NSString *errMsg))callback;


/**
 历史上的"今天"查询

 @param dateStr 日期(格式:MMdd)，必填项，不允许为nil
 @param callback 回调
 */
+ (void)loadHistoryListWithDateStr:(NSString *)dateStr
                          callback:(void (^)(MOBAResponse *response, NSArray<MARHistoryDayModel *> *historyDayArray, NSString *errMsg))callback;

/**
 微信精选分类查询

 @param callback 回调
 */
+ (void)loadWXArticleCategoryCallback:(void (^)(MOBAResponse *response, NSArray<MARWXArticleCategoryModel *> *articleArray, NSString *errMsg))callback;

/**
 微信精选列表查询

 @param cid 分类id，必填项，不允许为nil
 @param callback 回调
 */
+ (void)loadWXArticleListWithCid:(NSString *)cid
                       pageModel:(MARLoadPageModel *)pageModel
                        callback:(void (^)(MOBAResponse *response, NSArray<MARWXArticleModel *> *articles, NSString *errMsg))callback;

@end
