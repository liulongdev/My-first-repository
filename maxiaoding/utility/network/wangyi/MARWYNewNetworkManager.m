//
//  MARWYNewNetworkManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
@implementation MARWYNewNetworkManager

+ (void)getNewTitleListSuccess:(void (^)(NSArray<MARWYNewCategoryTitleModel *> *))success
                       failure:(MARNetworkFailure)failure
{
    [MARNetworkManager mar_get:WYSERVER_GetAllNewCategoryTitleList parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray<MARWYNewCategoryTitleModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYNewCategoryTitleModel class] json:responseObject[@"tList"]];
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getNewArticleList:(MARWYGetNewArticleListR *)param
                  success:(void (^)(NSArray<MARWYNewModel *> *))success
                  failure:(MARNetworkFailure)failure
{
    NSString *url = WYSERVER_GetNewArticleList;
    [MARNetworkManager mar_get:url parameters:param success:^(NSURLSessionTask *task, id responseObject) {
        NSArray<MARWYNewModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYNewModel class] json:responseObject[param.from?:@""]];
        if (array.count == 1) array = nil;
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getNewArticleList2:(MARWYGetNewArticleListR *)param
                   success:(void (^)(NSArray<MARWYNewModel *> *))success
                   failure:(MARNetworkFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@-%@.html", WYSERVER_GetNewArticleList2, param.from,  MARSTRWITHINT(param.offset), MARSTRWITHINT(param.size)];
    [MARNetworkManager mar_get:url parameters:param success:^(NSURLSessionTask *task, id responseObject) {
        NSArray<MARWYNewModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYNewModel class] json:responseObject[param.from?:@""]];
        if (array.count == 1) array = nil;
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getNewArticleList3:(MARWYGetNewArticleListR *)param
                   success:(void (^)(NSArray<MARWYNewModel *> *))success
                   failure:(MARNetworkFailure)failure
{
    [param setSignature];
    NSString *urlParam = [NSString stringWithFormat:@"%@?%@", WYSERVER_GetNewArticleList3, AFQueryStringFromParameters([param mar_modelToJSONObject])];
    
    MARBaseRequest *request = [MARBaseRequest new];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:[request mar_modelToJSONObject]];
    paramDic[@"url"] = urlParam?: @"";
    paramDic[@"method"] = @"GET";
    NSString *url = [NSString stringWithFormat:@"%@/api/core/delegation/wy/special", LIULONGHOST];
    [MARNetworkManager mar_post:url parameters:paramDic success:^(NSURLSessionTask *task, id responseObject) {
        
        MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
        
        NSDictionary *wyResponseDic = [response.body mar_jsonValueDecoded];
        NSString *key = @"";
        if ([wyResponseDic isKindOfClass:[NSDictionary class]] && [wyResponseDic allKeys].count == 1) {
            key = [wyResponseDic allKeys][0] ?: @"";
        }
        NSArray *array = [NSArray mar_modelArrayWithClass:[MARWYVideoNewModel class] json:wyResponseDic[key]];
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getNewArticleList4:(MARWYGetNewArticleListR *)param
                   success:(void (^)(NSArray<MARWYNewModel *> *))success
                   failure:(MARNetworkFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@/%@", WYSERVER_GetNewArticleList4, param.from];
    [MARNetworkManager mar_get:url parameters:param success:^(NSURLSessionTask *task, id responseObject) {
        NSString *key = @"";
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject allKeys].count == 1) {
            key = [responseObject allKeys][0] ?: @"";
        }
        else
        {
            key = responseObject[param.from ?: @""];
        }
        NSArray<MARWYNewModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYNewModel class] json:responseObject[key ?: @""]];
        if (array.count == 1) array = nil;
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getRecommendNewList:(MARWYGetNewArticleListR *)param
                  success:(void (^)(NSArray<MARWYNewModel *> *))success
                  failure:(MARNetworkFailure)failure
{
    [MARNetworkManager mar_get:WYSERVER_GetRecommendNewList parameters:param success:^(NSURLSessionTask *task, id responseObject) {
        NSString *key = @"";
        if ([responseObject allKeys].count > 0) {
            key = [responseObject allKeys][0];
        }
        else
        {
            key = @"data";
        }
        NSArray<MARWYNewModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYNewModel class] json:responseObject[key]];
        if (array.count == 1) array = nil;
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getChanListNews:(MARWYGetNewArticleListR *)param
                success:(void (^)(NSArray<MARWYNewModel *> *))success
                failure:(MARNetworkFailure)failure
{
    [MARNetworkManager mar_get:WYSERVER_GetChanListNews parameters:param success:^(NSURLSessionTask *task, id responseObject) {
        NSString *key = @"";
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject allKeys].count == 1) {
            key = [responseObject allKeys][0] ?: @"";
        }
        else
        {
            key = responseObject[param.from ?: @""];
        }
        NSArray<MARWYNewModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYNewModel class] json:responseObject[key ?: @""]];
        if (array.count == 1) array = nil;
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getVideoNewDetailWithSkipId:(NSString *)skipId
                            success:(MARNetworkSuccess)success
                            failure:(MARNetworkFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@/%@.html", WYSERVER_GetVideoNewDetail, skipId];
    [MARNetworkManager mar_get:url parameters:nil success:success failure:failure];
}

+ (void)getNewDetailWithDocId:(NSString *)docId
                      success:(MARNetworkSuccess)success
                      failure:(MARNetworkFailure)failure
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/full.html", WYSERVER_GETNewDetailWithDocId, docId];
    [MARNetworkManager mar_get:url parameters:nil success:success failure:failure];
}

+ (void)getVideoCategoryTitleListSuccess:(void (^)(NSArray<MARWYVideoCategoryTitleModel *> *))success
                                 failure:(MARNetworkFailure)failure
{
    [MARNetworkManager mar_get:WYSERVER_GetVideoCategoryTitleList parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray<MARWYVideoCategoryTitleModel *> *array = [NSArray mar_modelArrayWithClass:[MARWYVideoCategoryTitleModel class] json:responseObject];
        if (success) {
            success(array);
        }
    } failure:failure];
}

+ (void)getVideoNewList:(MARWYGetVideoNewListR *)param success:(void (^)(NSArray<MARWYVideoNewModel *> *))success failure:(MARNetworkFailure)failure
{
    NSString *urlParam = [NSString stringWithFormat:@"%@?%@",  WYSERVER_GetVideoNewList, AFQueryStringFromParameters([param mar_modelToJSONObject])];
    MARBaseRequest *request = [MARBaseRequest new];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:[request mar_modelToJSONObject]];
    paramDic[@"url"] = urlParam?: @"";
    paramDic[@"method"] = @"GET";
    NSString *url = [NSString stringWithFormat:@"%@/api/core/delegation/wy/special", LIULONGHOST];
    [MARNetworkManager mar_post:url parameters:paramDic success:^(NSURLSessionTask *task, id responseObject) {
        
        MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
        
        NSDictionary *wyResponseDic = [response.body mar_jsonValueDecoded];
        NSString *key = @"";
        if ([wyResponseDic isKindOfClass:[NSDictionary class]] && [wyResponseDic allKeys].count == 1) {
            key = [wyResponseDic allKeys][0] ?: @"";
        }
        NSArray *array = [NSArray mar_modelArrayWithClass:[MARWYVideoNewModel class] json:wyResponseDic[key]];
        if (success) {
            success(array);
        }
    } failure:failure];
}

@end
