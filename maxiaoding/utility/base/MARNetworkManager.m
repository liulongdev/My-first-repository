//
//  MARNetworkManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARNetworkManager.h"
#import <NSObject+MARModel.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>
#import "MARBaseRequest.h"
#import <UIApplication+MAREX.h>
@interface MARNetworkManager ()

@end

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

- (instancetype)init
{
    return [[self.class alloc] initWithBaseURL:nil];
}

+ (instancetype)instance
{
    return [[self.class alloc] initWithBaseURL:nil];
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
    
    MARBaseRequest *baseR = [MARBaseRequest new];
    [self.requestSerializer setValue:[baseR mar_modelToJSONString] forHTTPHeaderField:@"mar-signature"];
    
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

- (NSURLSessionDataTask *)_mar_requestType:(MARNetworkRequestType)type
                                 urlString:(NSString *)urlString
                                parameters:(id)parameters
                                  progress:(MARNetworkProgress)progress
                                   success:(MARNetworkSuccess)success
                                   failure:(MARNetworkFailure)failure
                               loadingType:(MARNetworkLoadingType)loadingType     // 备用
                                    inView:(UIView *)inView
{
    NSURLSessionDataTask *task;
    ALBBMANNetworkHitBuilder *builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:task.originalRequest.URL.host method:task.originalRequest.HTTPMethod];
    __weak __typeof(self) weakSelf = self;
    switch (type) {
        case MARNetworkRequestTypeGet:
        {
            [[UIApplication sharedApplication] mar_startNetworkActivity];
            task = [self GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[UIApplication sharedApplication] mar_endedNetworkActivity];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task builder:builder];
                if (success) {
                    success(task, responseObject);
//                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
//                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[UIApplication sharedApplication] mar_endedNetworkActivity];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error builder:builder];
                }
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        case MARNetworkRequestTypePost:
        {
            [[UIApplication sharedApplication] mar_startNetworkActivity];
            task = [self POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[UIApplication sharedApplication] mar_endedNetworkActivity];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task builder:builder];
                if (success) {
                    success(task, responseObject);
//                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
//                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[UIApplication sharedApplication] mar_endedNetworkActivity];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error builder:builder];
                }
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        case MARNetworkRequestTypeDelete:
        {
            [[UIApplication sharedApplication] mar_startNetworkActivity];
            task = [self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[UIApplication sharedApplication] mar_endedNetworkActivity];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task builder:builder];
                if (success) {
                    success(task, responseObject);
//                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
//                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[UIApplication sharedApplication] mar_endedNetworkActivity];
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error builder:builder];
                }
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
    }
    if (task) {
        [builder requestStart];
    }
    return task;
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
    return [[self shareManager] _mar_requestType:type urlString:urlString parameters:parameters progress:progress success:success failure:failure loadingType:loadingType inView:inView];
}

- (NSURLSessionDataTask *)_mar_requestType:(MARNetworkRequestType)type
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

- (NSURLSessionDataTask *)mar_requestType:(MARNetworkRequestType)type
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

- (NSURLSessionDataTask *)mar_get:(NSString *)urlString
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

- (NSURLSessionDataTask *)mar_get:(NSString *)urlString
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

- (NSURLSessionDataTask *)mar_post:(NSString *)urlString
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

- (NSURLSessionDataTask *)mar_post:(NSString *)urlString
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

- (NSURLSessionDataTask *)mar_delete:(NSString *)urlString
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

- (NSURLSessionDataTask*)mar_request:(NSURLRequest *)request
                             success:(void (^)(NSURLResponse *, id))success
                             failure:(void (^)(NSURLResponse *, id))failure
{
    ALBBMANNetworkHitBuilder *builder = nil;
    if (request) {
        builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:request.URL.host method:request.HTTPMethod];
        [builder requestStart];
    }
    NSURLSessionDataTask *datatask = nil;
    __weak __typeof(self) weakSelf = self;
    datatask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[UIApplication sharedApplication] mar_endedNetworkActivity];
        if (error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithError:error builder:builder];
            if (failure) {
                failure(response, error);
            }
        }
        else
        {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithTask:datatask builder:builder];
            if (success) {
                success(response, responseObject);
            }
        }
    }];
    [[UIApplication sharedApplication] mar_startNetworkActivity];
    [datatask resume];
    return datatask;
}

+ (NSURLSessionDataTask*)mar_request:(NSURLRequest *)request
                             success:(void (^)(NSURLResponse *, id))success
                             failure:(void (^)(NSURLResponse *, id))failure
{
    return [[self shareManager] mar_request:request success:success failure:failure];
}

- (NSURLSessionUploadTask *)mar_uploadRequest:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                                     progress:(MARNetworkProgress)progress
                                      success:(void (^)(NSURLResponse *, id))success
                                      failure:(void (^)(NSURLResponse *, NSError *))failure
{
    NSURLSessionUploadTask *uploadTask = nil;
    __weak __typeof(self) weakSelf = self;
    ALBBMANNetworkHitBuilder *builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:uploadTask.originalRequest.URL.host method:uploadTask.originalRequest.HTTPMethod];;
    uploadTask = [self uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        if (error) {
            if (failure) {
                failure(response, error);
            }
            [strongSelf _alynasisRequestEndWithError:error builder:builder];
        }
        else
        {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithTask:uploadTask builder:builder];
            if (success) {
                success(response,responseObject);
            }
        }
        
    }];
    [uploadTask resume];
    
    if (uploadTask) {
        [builder requestStart];
    }

    return uploadTask;
}

+ (NSURLSessionUploadTask *)mar_uploadRequest:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                                     progress:(MARNetworkProgress)progress
                                      success:(void (^)(NSURLResponse *, id))success
                                      failure:(void (^)(NSURLResponse *, NSError *))failure
{
    return [[self shareManager] mar_uploadRequest:request fromData:bodyData progress:progress success:success failure:failure];
}


/**
 网络请求是否可到达
 
 @return YES可达到，NO不可到达
 */
+(BOOL)mar_reachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (void)_alynasisRequestEndWithError:(NSError *)error builder:(ALBBMANNetworkHitBuilder *)builder
{
    if (!builder) return;
    ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:MARSTRWITHINT(error.code)];
    [networkError setProperty:@"errMsg" value:error.localizedDescription ?: @"errMsg"];
    [networkError setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
    [networkError setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
    [networkError setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    [builder requestEndWithError:networkError];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

- (void)_alynasisRequestEndWithTask:(NSURLSessionDataTask *)task builder:(ALBBMANNetworkHitBuilder *)builder
{
    if (!builder) return;
    [builder requestEndWithBytes:task.countOfBytesReceived];
    [builder setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
    [builder setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
    [builder setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[builder build]];
}

@end
