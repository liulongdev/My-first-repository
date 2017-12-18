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
@interface MARNetworkManager ()
@property (nonatomic, strong) ALBBMANNetworkHitBuilder *builder;
@end

@implementation MARNetworkManager

#pragma mark - shareManager
//+(instancetype)shareManager
//{
//    static MARNetworkManager * manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[self alloc] initWithBaseURL:nil];
//    });
//
//    return manager;
//}

- (instancetype)init
{
    return [[self.class alloc] initWithBaseURL:nil];
}

+ (instancetype)instance
{
    return [[self.class alloc] initWithBaseURL:nil];
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
    __weak __typeof(self) weakSelf = self;
    switch (type) {
        case MARNetworkRequestTypeGet:
        {
            task = [self GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                [strongSelf _alynasisRequestEndWithTask:task];
                if (success) {
                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error];
                }
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        case MARNetworkRequestTypePost:
        {
            task = [self POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _alynasisRequestEndWithTask:task];
                if (success) {
                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error];
                }
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
        case MARNetworkRequestTypeDelete:
        {
            task = [self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _alynasisRequestEndWithTask:task];
                if (success) {
                    MARNetworkResponse *responce = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                    success(task, responce);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                if(error)
                {
                    [strongSelf _alynasisRequestEndWithError:error];
                }
                if (failure) {
                    failure(task, error);
                }
            }];
        }
            break;
    }
    if (task) {
        _builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:task.originalRequest.URL.host method:task.originalRequest.HTTPMethod];
        [_builder requestStart];
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
    return [[self instance] _mar_requestType:type urlString:urlString parameters:parameters progress:progress success:success failure:failure loadingType:loadingType inView:inView];
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

- (NSURLSessionDataTask*)mar_request:(NSURLRequest *)request
                             success:(void (^)(NSURLResponse *, id))success
                             failure:(void (^)(NSURLResponse *, id))failure
{
    if (request) {
        _builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:request.URL.host method:request.HTTPMethod];
        [_builder requestStart];
    }
    NSURLSessionDataTask *datatask = nil;
    __weak __typeof(self) weakSelf = self;
    datatask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithError:error];
            if (failure) {
                failure(response, error);
            }
        }
        else
        {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithTask:datatask];
            if (success) {
                success(response, responseObject);
            }
        }
    }];
    [datatask resume];
    
    return datatask;
}

+ (NSURLSessionDataTask*)mar_request:(NSURLRequest *)request
                             success:(void (^)(NSURLResponse *, id))success
                             failure:(void (^)(NSURLResponse *, id))failure
{
    return [[self instance] mar_request:request success:success failure:failure];
}

- (NSURLSessionUploadTask *)mar_uploadRequest:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                                     progress:(MARNetworkProgress)progress
                                      success:(void (^)(NSURLResponse *, id))success
                                      failure:(void (^)(NSURLResponse *, NSError *))failure
{
    NSURLSessionUploadTask *uploadTask = nil;
    __weak __typeof(self) weakSelf = self;
    uploadTask = [self uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        if (error) {
            if (failure) {
                failure(response, error);
            }
            [strongSelf _alynasisRequestEndWithError:error];
        }
        else
        {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            [strongSelf _alynasisRequestEndWithTask:uploadTask];
            if (success) {
                MARNetworkResponse *responseModel = [MARNetworkResponse mar_modelWithDictionary:responseObject];
                success(response,responseModel);
            }
        }
        
    }];
    [uploadTask resume];
    
    if (uploadTask) {
        _builder = [[ALBBMANNetworkHitBuilder alloc] initWithHost:uploadTask.originalRequest.URL.host method:uploadTask.originalRequest.HTTPMethod];
        [_builder requestStart];
    }

    return uploadTask;
}

+ (NSURLSessionUploadTask *)mar_uploadRequest:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                                     progress:(MARNetworkProgress)progress
                                      success:(void (^)(NSURLResponse *, id))success
                                      failure:(void (^)(NSURLResponse *, NSError *))failure
{
    return [[self instance] mar_uploadRequest:request fromData:bodyData progress:progress success:success failure:failure];
}


/**
 网络请求是否可到达
 
 @return YES可达到，NO不可到达
 */
+(BOOL)mar_reachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (void)_alynasisRequestEndWithError:(NSError *)error
{
    if (!_builder) return;
    ALBBMANNetworkError *networkError = [[ALBBMANNetworkError alloc] initWithErrorCode:MARSTRWITHINT(error.code)];
    [networkError setProperty:@"errMsg" value:error.localizedDescription ?: @"errMsg"];
    [networkError setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
    [networkError setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
    [networkError setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    [_builder requestEndWithError:networkError];
    // 组装日志并发送
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[_builder build]];
}

- (void)_alynasisRequestEndWithTask:(NSURLSessionDataTask *)task
{
    if (!_builder) return;
    [_builder requestEndWithBytes:task.countOfBytesReceived];
    [_builder setProperty:@"wifiip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: @"wifiip"];
    [_builder setProperty:@"cellip" value:[UIDevice currentDevice].mar_ipAddressCell ?: @"cellip"];
    [_builder setProperty:@"ip" value:[UIDevice currentDevice].mar_ipAddressWIFI ?: ([UIDevice currentDevice].mar_ipAddressCell ?: @"ip")];
    ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    [tracker send:[_builder build]];
}

@end
