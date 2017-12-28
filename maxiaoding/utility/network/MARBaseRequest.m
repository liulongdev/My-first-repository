//
//  MARBaseRequest.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/26.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseRequest.h"
#import <FCUUID.h>
@implementation MARBaseRequest

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _appVersion = AppVersion;
    _deviceType = @"iOS";
    _deviceUUID = [FCUUID uuidForDevice];
    _modelName = [UIDevice currentDevice].mar_machineModelName;
    _osVersion = [[UIDevice currentDevice] systemVersion];
    _timeStamp = MARSTRWITHINT((long)([[NSDate new] timeIntervalSince1970]));
    
    return self;
}

- (NSString *)signature
{
    NSString *originalSig = [NSString stringWithFormat:@"appVersion%@deviceType%@deviceUUID%@modelName%@osVersion%@timeStamp%@", _appVersion?:@"",_deviceType?:@"",_deviceUUID?:@"",_modelName?:@"",_osVersion?:@"",_timeStamp?:@""];
    return [originalSig mar_hmacSHA256StringWithKey:@"HelloMartin"];
}

@end
