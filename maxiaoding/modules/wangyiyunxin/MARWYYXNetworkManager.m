//
//  MARWYYXNetworkManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/5/18.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYYXNetworkManager.h"

@implementation MARWYYXNetworkManager

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) return nil;;
    
    return self;
}

- (NSURLSessionDataTask *)_mar_requestType:(MARNetworkRequestType)type urlString:(NSString *)urlString parameters:(id)parameters progress:(MARNetworkProgress)progress success:(MARNetworkSuccess)success failure:(MARNetworkFailure)failure loadingType:(MARNetworkLoadingType)loadingType inView:(UIView *)inView
{
    [self mar_setWYYXHeader];
    NSString *wrapUrlString = [urlString copy];
    if (parameters) {
        wrapUrlString = [wrapUrlString stringByAppendingFormat:@"?%@", AFQueryStringFromParameters([parameters mar_modelToJSONObject])];
    }
    return [super _mar_requestType:type urlString:wrapUrlString parameters:parameters progress:progress success:success failure:failure loadingType:loadingType inView:inView];
}

- (void)mar_setWYYXHeader
{
    NSString *currentTime = [NSString stringWithFormat:@"%.f", [[NSDate new] timeIntervalSince1970]];
    NSString *appKey = @"f98bfbd723373582824634e8699d0d77";
    NSString *secretKey = @"8f300abc0e68";
    NSString *randomUUID = [NSString mar_stringWithUUID];
    NSString *signature = [[[secretKey stringByAppendingString:randomUUID] stringByAppendingString:currentTime] mar_sha1String];
    NSDictionary *header = @{
                             @"AppKey":appKey,
                             @"Nonce":randomUUID,
                             @"CurTime": currentTime,
                             @"CheckSum": signature
                             };
    for (NSString *key in header) {
        [self.requestSerializer setValue:header[key] forHTTPHeaderField:key];
    }
}

@end
