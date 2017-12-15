//
//  MARMobUtil.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobUtil.h"

@implementation MARMobUtil

+ (instancetype)sharedInstance
{
    MARSINGLE_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

+ (NSDictionary *)mobErrorDic
{
    return MARMOBUTIL.mobErrorDic;
}

- (NSDictionary *)mobErrorDic
{
    if (!_mobErrorDic) {
        NSString *mobErrorPlistPath = [[NSBundle mainBundle] pathForResource:@"mob_error" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:mobErrorPlistPath];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            _mobErrorDic = dic;
        }
    }
    return _mobErrorDic;
    
    /*
     
     MARGLOBALMANAGER.dataFormatter.dateFormat = @"yyyy-MM-dd";
     [MobAPI sendRequest:[MOBACalendarRequest calendarRequestWithDate:[MARGLOBALMANAGER.dataFormatter stringFromDate:[NSDate new]]] onResult:^(MOBAResponse *response) {
     NSLog(@"response >>>> %@", response.responder);
     }];

     */
}

+ (void)loadCalendarWithDateStr:(NSString *)dateStr
                       callback:(void (^)(MOBAResponse *, MARMobCalendarModel *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACalendarRequest calendarRequestWithDate:dateStr] onResult:^(MOBAResponse *response) {
        MARMobCalendarModel *calendarModel = nil;
        if (!response.error) {
            calendarModel = [MARMobCalendarModel mar_modelWithJSON:response.responder[@"result"]];
        }
        else
        {
            
        }
        if (callback) {
            callback(response, calendarModel, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
        NSLog(@"response >>>> %@", response.responder);
    }];
}

+ (void)loadCalendarWithDate:(NSDate *)date
                    callback:(void (^)(MOBAResponse *, MARMobCalendarModel *, NSString *))callback
{
    if (!date) {
        return;
    }
    MARGLOBALMANAGER.dataFormatter.dateFormat = @"yyyy-MM-dd";
    [self loadCalendarWithDateStr:[MARGLOBALMANAGER.dataFormatter stringFromDate:date]  callback:callback];
}

+ (void)loadCarBrandListCallback:(void (^)(MOBAResponse *, NSArray<MARCarBrandModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACarRequest carBrandRequest] onResult:^(MOBAResponse *response) {
        NSArray<MARCarBrandModel *> *cardBrandArray = nil;
        if (!response.error) {
            cardBrandArray = [NSArray mar_modelArrayWithClass:[MARCarBrandModel class] json:response.responder[@"result"]];
        }
        if (callback) {
            callback(response, cardBrandArray, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
    }];
}

+ (void)loadCarSeriesName:(NSString *)name
                 callback:(void (^)(MOBAResponse *, NSArray<MARCarSerieModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACarRequest carSeriesNameRequestByName:(name ?: @"")] onResult:^(MOBAResponse *response) {
        NSArray<MARCarSerieModel *> *cardSerieArray = nil;
        if (!response.error) {
            cardSerieArray = [NSArray mar_modelArrayWithClass:[MARCarSerieModel class] json:response.responder[@"result"]];
        }
        if (callback) {
            callback(response, cardSerieArray, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
    }];
}

+ (void)loadCarSeriesDetailWithCid:(NSString *)cid
                          callback:(void (^)(MOBAResponse *, MARCarDetailModel *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACarRequest carSeriesDetailRequestByCid:cid] onResult:^(MOBAResponse *response) {
        MARCarDetailModel *cardDetailModel = nil;
        if (!response.error) {
            cardDetailModel = (MARCarDetailModel *)[MARCarDetailModel mar_modelWithJSON:response.responder[@"result"][0]];
            cardDetailModel.carId = cid;
        }
        if (callback) {
            callback(response, cardDetailModel, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
    }];
}

+ (void)loadHistoryListWithDateStr:(NSString *)dateStr
                          callback:(void (^)(MOBAResponse *, NSArray<MARHistoryDayModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBAHistoryRequest historyRequestWithDay:dateStr] onResult:^(MOBAResponse *response) {
        NSArray<MARHistoryDayModel *> *historyDayArray = nil;
        if (!response.error) {
            historyDayArray = [NSArray mar_modelArrayWithClass:[MARHistoryDayModel class] json:response.responder[@"result"]];
        }
        if (callback) {
            callback(response, historyDayArray, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
    }];
}

+ (void)loadWXArticleCategoryCallback:(void (^)(MOBAResponse *, NSArray<MARWXArticleCategoryModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleCategoryRequest] onResult:^(MOBAResponse *response) {
        NSArray<MARWXArticleCategoryModel *> *articleArray = nil;
        if (!response.error) {
            articleArray = [NSArray mar_modelArrayWithClass:[MARWXArticleCategoryModel class] json:response.responder[@"result"]];
        }
        if (callback) {
            callback(response, articleArray, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
    }];
}

+ (void)loadWXArticleListWithCid:(NSString *)cid
                       pageModel:(MARLoadPageModel *)pageModel
                        callback:(void (^)(MOBAResponse *, NSArray<MARWXArticleModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleListRequestByCID:cid page:(pageModel.pageIndex+1) size:pageModel.pageSize] onResult:^(MOBAResponse *response) {
        NSArray<MARWXArticleModel *> *articles = nil;
        if (!response.error) {
            articles = [NSArray mar_modelArrayWithClass:[MARWXArticleModel class] json:response.responder[@"result"][@"list"]];
        }
        if (callback) {
            callback(response, articles, [self mobErrorDic][MARSTRWITHINT(response.error.code)]);
        }
    }];
}

@end
