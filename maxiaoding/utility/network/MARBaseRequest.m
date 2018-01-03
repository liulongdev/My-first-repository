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
@synthesize signature = _signature;
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _appVersion = AppVersion;
    _deviceType = @"iOS";
    _deviceUUID = [FCUUID uuidForDevice];
    _machineModel = [UIDevice currentDevice].mar_machineModel;
    _machineModelName = [UIDevice currentDevice].mar_machineModelName;
    _osVersion = [[UIDevice currentDevice] systemVersion];
    _timeStamp = MARSTRWITHINT((long)([[NSDate new] timeIntervalSince1970]));
    
    return self;
}

- (NSString *)signature
{
    NSString *originalSig = [NSString stringWithFormat:@"appVersion%@deviceType%@deviceUUID%@machineModel%@machineModelName%@osVersion%@timeStamp%@", _appVersion?:@"",_deviceType?:@"",_deviceUUID?:@"",_machineModel?:@"",_machineModelName?:@"",_osVersion?:@"",_timeStamp?:@""];
    return [originalSig mar_hmacSHA256StringWithKey:MARCRYPTOHMACSHA256KEY];
}

@end
