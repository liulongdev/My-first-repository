//
//  MARALIAPINetworkManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/29.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARALIAPINetworkManager.h"
#define  MAAAPPCODE @"31635eeb39ac4cbbbad59604da93a968"
@interface MARALIAPIModel : NSObject
@property (nonatomic, strong) NSString *appCode;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSDictionary *queryDic;
@property (nonatomic, strong) NSString *bodys;

@end

@implementation MARALIAPIModel

@end

@implementation MARALIAPINetworkManager

+ (void)p_reqeustWithModel:(MARALIAPIModel *)model
                   success:(MARNetworkSuccess)success
                   failure:(MARNetworkFailure)failure
{
    NSString *query = @"";
    if (model.queryDic && [model.queryDic allKeys].count > 0) {
        query = [@"?" stringByAppendingString:AFQueryStringFromParameters(model.queryDic)];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@%@",model.host, model.path, query];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url ?: @""]];
    request.HTTPMethod = model.method;
    if ([model.method isEqual:@"POST"]) {
        request.HTTPBody = [model.bodys dataUsingEncoding:NSUTF8StringEncoding];
    }
    [request addValue:[NSString stringWithFormat:@"APPCODE %@", model.appCode] forHTTPHeaderField:@"Authorization"];
    __block NSURLSessionDataTask *task = [MARNetworkManager mar_request:request success:^(NSURLResponse *URLresponse, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLResponse *URLresponse, id error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
}

+ (void)weather_getCitiesSuccess:(void (^)(NSArray<MAAWeatherCityModel *> *))success
                         failure:(MARNetworkFailure)failure
{
    MARALIAPIModel *model = [MARALIAPIModel new];
    model.appCode = MAAAPPCODE;
    model.host = @"http://jisutqybmf.market.alicloudapi.com";
    model.path = @"/weather/city";
    model.method = @"GET";
    model.queryDic = nil;
    model.bodys = nil;
    
    [self p_reqeustWithModel:model success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            NSArray<MAAWeatherCityModel *> *cityArray = [NSArray mar_modelArrayWithClass:[MAAWeatherCityModel class] json:responseObject[@"result"]];
            if (success) {
                success(cityArray);
            }
        }
        else
        {
            failure(nil, [NSError errorWithDomain:@"NSALIAPIWeatherErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"] ?: @"网络不稳定，请重试～"}]);
        }
    } failure:failure];
}

+ (void)weather_getWeather:(MAAGetWeatherR *)param
                   success:(void (^)(MAAWeatherModel *))success
                   failure:(MARNetworkFailure)failure
{
    MARALIAPIModel *model = [MARALIAPIModel new];
    model.appCode = MAAAPPCODE;
    model.host = @"http://jisutqybmf.market.alicloudapi.com";
    model.path = @"/weather/query";
    model.method = @"GET";
    model.queryDic = [param mar_modelToJSONObject];
    model.bodys = nil;
    
    [self p_reqeustWithModel:model success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            MAAWeatherModel *weatherM = [MAAWeatherModel mar_modelWithJSON:responseObject[@"result"]];
            if (success) {
                success(weatherM);
            }
        }
        else
        {
            failure(nil, [NSError errorWithDomain:@"NSALIAPIWeatherErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"] ?: @"网络不稳定，请重试～"}]);
        }
    } failure:failure];
}

+ (void)car_getAllBrandSuccess:(void (^)(NSArray<MAACarBrandM *> *))success
                       failure:(MARNetworkFailure)failure
{
    MARALIAPIModel *model = [MARALIAPIModel new];
    model.appCode = MAAAPPCODE;
    model.host = @"http://jisucxdq.market.alicloudapi.com";
    model.path = @"/car/brand";
    model.method = @"GET";
    model.queryDic = nil;
    model.bodys = nil;
    
    [self p_reqeustWithModel:model success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            NSArray<MAACarBrandM *> *carBrandArray = [NSArray mar_modelArrayWithClass:[MAACarBrandM class] json:responseObject[@"result"]];
            if (success) {
                success(carBrandArray);
            }
        }
        else
        {
            failure(nil, [NSError errorWithDomain:@"NSALIAPICarErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"] ?: @"网络不稳定，请重试～"}]);
        }
    } failure:failure];
}

+(void)car_getCarFactoriesByBrandID:(NSString *)carBrandID
                            success:(void (^)(NSArray<MAACarFactoryM *> *))success
                            failure:(MARNetworkFailure)failure
{
    MARALIAPIModel *model = [MARALIAPIModel new];
    model.appCode = MAAAPPCODE;
    model.host = @"http://jisucxdq.market.alicloudapi.com";
    model.path = @"/car/carlist";
    model.method = @"GET";
    model.queryDic = @{@"parentid": carBrandID ?: @""};
    model.bodys = nil;
    
    [self p_reqeustWithModel:model success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            NSArray<MAACarFactoryM *> *carFactoryArray = [NSArray mar_modelArrayWithClass:[MAACarFactoryM class] json:responseObject[@"result"]];
            if (success) {
                success(carFactoryArray);
            }
        }
        else
        {
            failure(nil, [NSError errorWithDomain:@"NSALIAPICarErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"] ?: @"网络不稳定，请重试～"}]);
        }
    } failure:failure];
}

+ (void)car_getCarDetailWithCarID:(NSString *)carID
                          success:(void (^)(MAACarModel *))success
                          failure:(MARNetworkFailure)failure
{
    MARALIAPIModel *model = [MARALIAPIModel new];
    model.appCode = MAAAPPCODE;
    model.host = @"http://jisucxdq.market.alicloudapi.com";
    model.path = @"/car/detail";
    model.method = @"GET";
    model.queryDic = @{@"carid": carID ?: @""};
    model.bodys = nil;
    
    [self p_reqeustWithModel:model success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            MAACarModel *carModel = [MAACarModel mar_modelWithJSON:responseObject[@"result"]];
            if (success) {
                success(carModel);
            }
        }
        else
        {
            failure(nil, [NSError errorWithDomain:@"NSALIAPICarErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"] ?: @"网络不稳定，请重试～"}]);
        }
    } failure:failure];
}

+ (void)new_getNewListWithType:(NSString *)type
                       success:(void (^)(NSArray<MAANewModel *> *))success
                       failure:(MARNetworkFailure)failure
{
    MARALIAPIModel *model = [MARALIAPIModel new];
    model.appCode = MAAAPPCODE;
    model.host = @"http://toutiao-ali.juheapi.com";
    model.path = @"/toutiao/index";
    model.method = @"GET";
    model.queryDic = @{@"type": type ?: @""};
    model.bodys = nil;
    
    [self p_reqeustWithModel:model success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject[@"error_code"] integerValue] == 0) {
            id data = nil;
            if ([responseObject[@"result"] isKindOfClass:[NSDictionary class]]) {
                data = responseObject[@"result"][@"data"];
            }
            NSArray *newArray = [NSArray mar_modelArrayWithClass:[MAANewModel class] json:data];
            if (success) {
                success(newArray);
            }
        }
        else
        {
            failure(nil, [NSError errorWithDomain:@"NSALIAPICarErrorDomain" code:300001 userInfo:@{NSLocalizedDescriptionKey:responseObject[@"msg"] ?: @"网络不稳定，请重试～"}]);
        }
    } failure:failure];
}

@end
