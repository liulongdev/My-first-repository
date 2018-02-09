//
//  MARUtility.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARGlobalModel.h"

typedef void(^MARCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

#define MARUTILITY [MARUtility sharedInstance]
@interface MARUtility : NSObject

+ (instancetype) sharedInstance;

+ (BOOL)isLogin;

+ (BOOL)isBindPhone;

- (BOOL)isLogin;

- (BOOL)isBindPhone;

@property (nonatomic, strong) NSTimer *quickLoginPhoneCodeTimer;

@property (nonatomic, strong) NSTimer *setPasswordPhoneCodeTimer;

@property (nonatomic, strong) NSTimer *bindPhoneCodeTimer;

- (NSString *)videoDiskPath;

- (void)clearImgDiskOnCompletion:(void (^)(void))completion;

- (void)clearVideoDiskOnCompletion:(void (^)(void))completion;

- (void)setPhoneCodeTimerWithType:(MARPhoneOperationType)operationType phone:(NSString *)phone;

- (void)calculateVideoCacheSizeWithCompletionBlock:(MARCalculateSizeBlock)completionBlock;

- (void)calculateImgCacheSizeWithCompletionBlock:(MARCalculateSizeBlock)completionBlock;

- (void)calculateSizeWithFolderPath:(NSString *)filePath
                    completionBlock:(MARCalculateSizeBlock)completionBlock;

- (NSString *)briefTimeStrWithDate:(NSDate *)date;

- (NSString *)briefTimeStrWithDateStr:(NSString *)dateStr;

// 第一次开启app调用的方法
- (void)firstStartApp;

// 升级后第一次开启app调用的方法
- (void)firstStartAppAfterUpdate;

// 启动app调用的方法
- (void)startApp;

@end
