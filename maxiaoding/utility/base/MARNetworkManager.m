//
//  MARNetworkManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARNetworkManager.h"
#import <NSObject+MARModel.h>

@implementation MARNetworkManager

#pragma mark - shareManager
+(instancetype)shareManager
{
    static MARNetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:nil];
    });
    
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) return nil;
    //  self.requestSerializer = [AFHTTPRequestSerializer serializer];
    //  self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    /**设置请求超时时间*/
    self.requestSerializer.timeoutInterval = 15;
    
    /**复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    [self.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
//    [self.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    // post 对paramter进行加密，加工放入request的httpbody前的string格式
    [self.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        if ([parameters isKindOfClass:[NSString class]]) {
            return parameters;
        }
        
        if ([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"]||[[request.HTTPMethod uppercaseString] isEqualToString:@"DELETE"])
        {
            NSString *paramString = [parameters mar_modelToJSONString];
//            NSString *decodeParamString = [MXRBase64 encodeBase64WithString:paramString];
//            return decodeParamString;
            return paramString;
        }else if([[request.HTTPMethod uppercaseString] isEqualToString:@"GET"] ){
            if ([parameters isKindOfClass:[NSDictionary class]]) {
                return AFQueryStringFromParameters(parameters);
            }
            return AFQueryStringFromParameters([parameters mar_modelToJSONObject]);
        }else {
            if ([parameters isKindOfClass:[NSDictionary class]]) {
                return AFQueryStringFromParameters(parameters);
            }
            return AFQueryStringFromParameters([parameters mar_modelToJSONObject]);
        }
        
        return parameters;
    }];
    
    /**设置接受的类型*/
    [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil]];
    
    return self;
}

+ (NSURLSessionDataTask *)_mar_requestType:(MARNetworkRequestType)type
                                 urlString:(NSString *)urlString
                                parameters:(id)parameters
                                  progress:(MARNetworkProgress)progress
                                   success:(MARNetworkSuccess)success
                                   failure:(MARNetworkFailure)failure
                               loadingType:(MARNetworkLoadingType)loadingType     // 备用
                                    inView:(UIView *)inView;                      // 备用
{
    NSURLSessionDataTask *task;
    
    switch (type) {
        case MARNetworkRequestTypeGet:
        {
            task = [[self shareManager] GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        case MARNetworkRequestTypePost:
        {
            task = [[self shareManager] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        case MARNetworkRequestTypeDelete:
        {
            task = [[self shareManager] DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
    }
    return task;
}

+ (NSURLSessionDataTask *)_mar_requestType:(MARNetworkRequestType)type
                                 urlString:(NSString *)urlString
                                parameters:(id)parameters
                                  progress:(MARNetworkProgress)progress
                                   success:(MARNetworkSuccess)success
                                   failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:type
                        urlString:urlString
                       parameters:parameters
                         progress:progress
                          success:success
                          failure:failure
                      loadingType:MARNetworkLoadingTypeNone
                           inView:nil];
}

+ (NSURLSessionDataTask *)mar_requestType:(MARNetworkRequestType)type
                                urlString:(NSString *)urlString
                               parameters:(id)parameters
                                 progress:(MARNetworkProgress)progress
                                  success:(MARNetworkSuccess)success
                                  failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:type
                        urlString:urlString
                       parameters:parameters
                         progress:progress
                          success:success
                          failure:failure];
}

+ (NSURLSessionDataTask *)mar_get:(NSString *)urlString
                       parameters:(id)parameters
                         progress:(MARNetworkProgress)progress
                          success:(MARNetworkSuccess)success
                          failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:MARNetworkRequestTypeGet
                        urlString:urlString parameters:parameters
                         progress:progress
                          success:success
                          failure:failure];
}

+ (NSURLSessionDataTask *)mar_get:(NSString *)urlString
                       parameters:(id)parameters
                          success:(MARNetworkSuccess)success
                          failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:MARNetworkRequestTypeGet
                        urlString:urlString
                       parameters:parameters
                         progress:nil
                          success:success
                          failure:failure];
}

+ (NSURLSessionDataTask *)mar_post:(NSString *)urlString
                        parameters:(id)parameters
                          progress:(MARNetworkProgress)progress
                           success:(MARNetworkSuccess)success
                           failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:MARNetworkRequestTypePost
                        urlString:urlString
                       parameters:parameters
                         progress:progress
                          success:success
                          failure:failure];
}

+ (NSURLSessionDataTask *)mar_post:(NSString *)urlString
                        parameters:(id)parameters
                           success:(MARNetworkSuccess)success
                           failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:MARNetworkRequestTypePost
                        urlString:urlString
                       parameters:parameters
                         progress:nil
                          success:success
                          failure:failure];
}

+ (NSURLSessionDataTask *)mar_delete:(NSString *)urlString
                          parameters:(id)parameters
                             success:(MARNetworkSuccess)success
                             failure:(MARNetworkFailure)failure
{
    return [self _mar_requestType:MARNetworkRequestTypeDelete
                        urlString:urlString
                       parameters:parameters
                         progress:nil
                          success:success
                          failure:failure];
}

+ (NSURLSessionDataTask*)mar_request:(NSURLRequest *)request
                             success:(void (^)(NSURLResponse *, id))success
                             failure:(void (^)(NSURLResponse *, id))failure
{
    NSURLSessionDataTask* datatask = [[self shareManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(response, error);
            }
        }
        else
        {
            if (success) {
                success(response, responseObject);
            }
        }
    }];
    [datatask resume];
    
    return datatask;
}

+ (NSURLSessionUploadTask *)mar_uploadRequest:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                                     progress:(MARNetworkProgress)progress
                                      success:(void (^)(NSURLResponse *, id))success
                                      failure:(void (^)(NSURLResponse *, NSError *))failure
{
    NSURLSessionUploadTask *uploadTask = [[self shareManager] uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(response, error);
            }
        }
        else
        {
            if (success) {
                MARNetworkResponse *responseModel = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                success(response,responseModel);
            }
        }
        
    }];
    [uploadTask resume];
    
    return uploadTask;
}


/**
 网络请求是否可到达
 
 @return YES可达到，NO不可到达
 */
+(BOOL)mar_reachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
