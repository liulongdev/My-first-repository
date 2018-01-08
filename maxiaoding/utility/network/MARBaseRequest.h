//
//  MARBaseRequest.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/26.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MARCRYPTOHMACSHA256KEY @"HelloMartin"

@interface MARBaseRequest : NSObject

@property (nonatomic, strong) NSString *appVersion;     // app版本号
@property (nonatomic, strong) NSString *deviceType;     // 设备型号
@property (nonatomic, strong) NSString *deviceUUID;     // 设备唯一标识
@property (nonatomic, strong) NSString *machineModel;   // 设备型号
@property (nonatomic, strong) NSString *machineModelName;      // 设备名称
@property (nonatomic, strong) NSString *osVersion;      // 设备系统版本
@property (nonatomic, strong) NSString *timeStamp;      // 请求时间戳
@property (nonatomic, strong) NSString *signature;      // 数字签名
@property (nonatomic, strong) NSString *currentUserId;  // 当前用户Id

@end
