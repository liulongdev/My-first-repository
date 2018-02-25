//
//  MARMobUtil.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobUtil.h"
#import "MARALIAPINetworkManager.h"
#import <CoreLocation/CoreLocation.h>
#import "UIApplication+MXD.h"
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
}

- (NSString *)errorMessageWithMobResponse:(MOBAResponse *)response
{
    if (response.error) {
        NSString *mobErrMsg = [self mobErrorDic][MARSTRWITHINT(response.error.code)];
        if (!mobErrMsg && response.error && [response.error.userInfo isKindOfClass:[NSDictionary class]]) {
            mobErrMsg = response.error.userInfo[@"error_message"];
        }
        return mobErrMsg;
    }
    return nil;
}

+ (NSString *)errorMessageWithMobResponse:(MOBAResponse *)response
{
    return [MARMOBUTIL errorMessageWithMobResponse:response];
}

+ (void)test
{
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    [[UIApplication sharedApplication] mxd_requestAccessToLocationWithSuccess:^{
//        NSLog(@">>>> success ");
//    } andFailure:^{
//        NSLog(@">>>> failure");
//    }];

    
//    NSArray *cityArray = [MAAWeatherCityModel cityArrayWithParentId:@"0"];
//    NSLog(@">>> count : %ld", cityArray.count);
    
//    [MARALIAPINetworkManager weather_getCitiesSuccess:^(NSArray<MAAWeatherCityModel *> *cityArray) {
//        NSLog(@">>>>> start time %f", [[NSDate date] timeIntervalSince1970]);
//        for (MAAWeatherCityModel *model in cityArray) {
//            [model updateToDB];
//        }
//        NSLog(@">>>>> end   time %f", [[NSDate date] timeIntervalSince1970]);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@">>>>>>>> RESPONSE ERROR : %@", error);
//    }];
//    MAAGetWeatherR *getWeatherR = [MAAGetWeatherR new];
//    getWeatherR.city = @"苏州";
//    [MARALIAPINetworkManager weather_getWeather:getWeatherR success:^(MAAWeatherModel *weatherM) {
//        NSLog(@">>>>>>>> responseObject: %@", weatherM);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@">>>>>>>> RESPONSE ERROR : %@", error);
//    }];
//    [MARALIAPINetworkManager car_getAllBrandSuccess:^(NSArray<MAACarBrandM *> *carBrandArray) {
//        NSLog(@">>>>>>>> responseObject: %@", carBrandArray);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@">>>>>>>> RESPONSE ERROR : %@", error);
//    }];
//    [MARALIAPINetworkManager car_getCarFactoriesByBrandID:@"1" success:^(NSArray<MAACarFactoryM *> *carFactoryArray) {
//        NSLog(@">>>>>>>> responseObject: %@", carFactoryArray);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@">>>>>>>> RESPONSE ERROR : %@", error);
//    }];
//    [MARALIAPINetworkManager car_getCarDetailWithCarID:@"2571" success:^(MAACarModel *carModel) {
//        NSLog(@">>>>>>>> responseObject: %@", carModel);
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@">>>>>>>> RESPONSE ERROR : %@", error);
//    }];
}

+ (void)loadCalendarWithDateStr:(NSString *)dateStr
                       callback:(void (^)(MOBAResponse *, MARMobCalendarModel *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACalendarRequest calendarRequestWithDate:dateStr] onResult:^(MOBAResponse *response) {
        MARMobCalendarModel *calendarModel = nil;
        if (!response.error) {
            calendarModel = [MARMobCalendarModel mar_modelWithJSON:response.responder[@"result"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [calendarModel updateToDB];
            });
        }
        else
        {
            
        }
        if (callback) {
            callback(response, calendarModel, MARMOBERRMSG(response));
        }
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

+ (void)loadLaohuangliWithDateStr:(NSString *)dateStr
                         callback:(void (^)(MOBAResponse *, MARLaohuangliModel *, NSString *))callback
{
    [MobAPI sendRequest:[MOBALaohuangliRequest laohuangliRequestWithDate:dateStr ?: @""] onResult:^(MOBAResponse *response) {
        MARLaohuangliModel *laohuangliModel = nil;
        if (!response.error) {
            laohuangliModel = response.responder[@"result"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [laohuangliModel updateToDB];
            });
        }
        if (callback) {
            callback(response, laohuangliModel, MARMOBERRMSG(response));
        }
    }];
}

+ (void)loadLaohuangliWithDate:(NSDate *)date callback:(void (^)(MOBAResponse *, MARLaohuangliModel *, NSString *))callback
{
    if (!date) {
        return;
    }
    MARGLOBALMANAGER.dataFormatter.dateFormat = @"yyyy-MM-dd";
    [self loadLaohuangliWithDateStr:[MARGLOBALMANAGER.dataFormatter stringFromDate:date]  callback:callback];
}

+ (void)loadCarBrandListCallback:(void (^)(MOBAResponse *, NSArray<MARCarBrandModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACarRequest carBrandRequest] onResult:^(MOBAResponse *response) {
        NSArray<MARCarBrandModel *> *cardBrandArray = nil;
        if (!response.error) {
            cardBrandArray = [NSArray mar_modelArrayWithClass:[MARCarBrandModel class] json:response.responder[@"result"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARCarBrandModel *model in cardBrandArray) {
                    [model updateToDB];
                }
            });
        }
        if (callback) {
            callback(response, cardBrandArray, MARMOBERRMSG(response));
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARCarSerieModel *model in cardSerieArray) {
                    [model updateToDB];
                }
            });
        }
        if (callback) {
            callback(response, cardSerieArray, MARMOBERRMSG(response));
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [cardDetailModel updateToDB];
            });
        }
        if (callback) {
            callback(response, cardDetailModel, MARMOBERRMSG(response));
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARHistoryDayModel *model in historyDayArray) {
                    [model updateToDB];
                }
            });
        }
        if (callback) {
            callback(response, historyDayArray, MARMOBERRMSG(response));
        }
    }];
}

+ (void)loadWXArticleCategoryCallback:(void (^)(MOBAResponse *, NSArray<MARWXArticleCategoryModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleCategoryRequest] onResult:^(MOBAResponse *response) {
        NSArray<MARWXArticleCategoryModel *> *articleArray = nil;
        if (!response.error) {
            articleArray = [NSArray mar_modelArrayWithClass:[MARWXArticleCategoryModel class] json:response.responder[@"result"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARWXArticleCategoryModel *model in articleArray) {
                    [model updateToDB];
                }
            });
        }
        if (callback) {
            callback(response, articleArray, MARMOBERRMSG(response));
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
            // 暂时没有用到
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARWXArticleModel *model in articles) {
                    [model updateToDB];
                }
            });
        }
        if (callback) {
            callback(response, articles, MARMOBERRMSG(response));
        }
    }];
}

+ (void)loadCookCategoriesCallback:(void (^)(MOBAResponse *, NSArray<MARCookCategoryMenuModel *> *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACookRequest categoryRequest] onResult:^(MOBAResponse *response) {
        NSMutableArray<MARCookCategoryMenuModel *> *categoryMenuArray = nil;
        if (!response.error) {
            NSDictionary *result = response.responder[@"result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *categoryMenus = result[@"childs"];
                if ([categoryMenus isKindOfClass:[NSArray class]] && categoryMenus.count > 0) {
                    categoryMenuArray = [NSMutableArray arrayWithCapacity:categoryMenus.count];
                    for (NSDictionary *categoryMenuDic in categoryMenus) {
                        if ([categoryMenuDic isKindOfClass:[NSDictionary class]]) {
                            MARCookCategoryMenuModel *menuModel = [MARCookCategoryMenuModel mar_modelWithJSON:categoryMenuDic[@"categoryInfo"]];
                            NSArray *categorys = categoryMenuDic[@"childs"];
                            if ([categorys isKindOfClass:[NSArray class]] && categorys.count > 0) {
                                NSMutableArray *categoryArray = [NSMutableArray array];
                                MARCookCategoryModel *categoryModel = nil;
                                for (int index = 0; index < categorys.count; index++) {
                                    if ([categorys[index] isKindOfClass:[NSDictionary class]]) {
                                        categoryModel = [MARCookCategoryModel mar_modelWithJSON:categorys[index][@"categoryInfo"]];
                                        [categoryArray addObject:categoryModel];
                                        
                                    }
                                }
                                menuModel.childs = categoryArray;
                            }
                            
                            [categoryMenuArray addObject:menuModel]; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [menuModel updateToDB];
                            });
                        }
                    }
                }
            }
        }
        if (callback) {
            callback(response, categoryMenuArray, MARMOBERRMSG(response));
        }
    }];
}

+ (void)loadCookDetailWithMid:(NSString *)mid
                     callback:(void (^)(MOBAResponse *, MARCookDetailModel *, NSString *))callback
{
    [MobAPI sendRequest:[MOBACookRequest infoDetailRequestById:mid ?: @""] onResult:^(MOBAResponse *response) {
        MARCookDetailModel *cookDetailModel = nil;
        if (!response.error) {
            cookDetailModel = [MARCookDetailModel mar_modelWithJSON:response.responder[@"result"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [cookDetailModel updateToDB];
            });
        }
        if (callback) {
            callback(response, cookDetailModel, MARMOBERRMSG(response));
        }
    }];
}

+ (void)loadCookListWithCid:(NSString *)cid
                   cookName:(NSString *)cookName
                   loadPage:(MARLoadPageModel *)pageModel
                   callback:(void (^)(MOBAResponse *, NSArray<MARCookDetailModel *> *, NSInteger, NSString *))callback
{
    [MobAPI sendRequest:[MOBACookRequest searchMenuRequestByCid:cid name:cookName page:pageModel.pageIndex + 1 size:pageModel.pageSize] onResult:^(MOBAResponse *response) {
        NSArray<MARCookDetailModel *> *cookArray = nil;
        NSInteger totalCount = 0;
        if (!response.error) {
            cookArray = [NSArray mar_modelArrayWithClass:[MARCookDetailModel class] json:response.responder[@"list"]];
            totalCount = [response.responder[@"total"] integerValue];
        }
        if (callback) {
            callback(response, cookArray, totalCount, MARMOBERRMSG(response));
        }
        
    }];
}

@end
