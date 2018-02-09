//
//  MARUtility.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARUtility.h"
#import <KTVHCPathTools.h>
#import "MAAWeatherModel.h"

#define force_inline __inline__ __attribute__((always_inline))
static force_inline NSDate *MARNSDateParseFromString(__unsafe_unretained NSString *string);
/// Parse string to date.
static force_inline NSDate *MARNSDateParseFromString(__unsafe_unretained NSString *string) {
    typedef NSDate* (^MARNSDateParseBlock)(NSString *string);
#define kParserNum 34
    static MARNSDateParseBlock blocks[kParserNum + 1] = {0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            /*
             2014-01-20  // Google
             */
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.dateFormat = @"yyyy-MM-dd";
            blocks[10] = ^(NSString *string) { return [formatter dateFromString:string]; };
        }
        
        {
            /*
             2014-01-20 12:24:48
             2014-01-20T12:24:48   // Google
             2014-01-20 12:24:48.000
             2014-01-20T12:24:48.000
             */
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter1.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
            
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter2.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            
            NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
            formatter3.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter3.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter3.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
            
            NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
            formatter4.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter4.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter4.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            
            blocks[19] = ^(NSString *string) {
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter1 dateFromString:string];
                } else {
                    return [formatter2 dateFromString:string];
                }
            };
            
            blocks[23] = ^(NSString *string) {
                if ([string characterAtIndex:10] == 'T') {
                    return [formatter3 dateFromString:string];
                } else {
                    return [formatter4 dateFromString:string];
                }
            };
        }
        
        {
            /*
             2014-01-20T12:24:48Z        // Github, Apple
             2014-01-20T12:24:48+0800    // Facebook
             2014-01-20T12:24:48+12:00   // Google
             2014-01-20T12:24:48.000Z
             2014-01-20T12:24:48.000+0800
             2014-01-20T12:24:48.000+12:00
             */
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            
            NSDateFormatter *formatter2 = [NSDateFormatter new];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            
            blocks[20] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[24] = ^(NSString *string) { return [formatter dateFromString:string]?: [formatter2 dateFromString:string]; };
            blocks[25] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[28] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
            blocks[29] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
        }
        
        {
            /*
             Fri Sep 04 00:12:21 +0800 2015 // Weibo, Twitter
             Fri Sep 04 00:12:21.000 +0800 2015
             */
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
            
            NSDateFormatter *formatter2 = [NSDateFormatter new];
            formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            formatter2.dateFormat = @"EEE MMM dd HH:mm:ss.SSS Z yyyy";
            
            blocks[30] = ^(NSString *string) { return [formatter dateFromString:string]; };
            blocks[34] = ^(NSString *string) { return [formatter2 dateFromString:string]; };
        }
    });
    if (!string) return nil;
    if (string.length > kParserNum) return nil;
    MARNSDateParseBlock parser = blocks[string.length];
    if (!parser) return nil;
    return parser(string);
#undef kParserNum
}

@implementation MARUtility

+ (instancetype)sharedInstance
{
    static MARUtility *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MARUtility alloc] init];
    });
    return instance;
}

- (BOOL)isLogin
{
    return [MARGLOBALMODEL.userInfo._id isKindOfClass:[NSString class]] && MARGLOBALMODEL.userInfo._id.length > 0;
}

- (BOOL)isBindPhone
{
    return [MARGLOBALMODEL.userInfo.phone mar_isMobileNumber];
}

+ (BOOL)isLogin
{
    return [[self sharedInstance] isLogin];
}

+ (BOOL)isBindPhone
{
    return [[self sharedInstance] isBindPhone];
}

- (void)setPhoneCodeTimerWithType:(MARPhoneOperationType)operationType phone:(NSString *)phone
{
    switch (operationType) {
        case MARPhoneOperationTypeQuickLogin:
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone?:@"", @"count": @(60), @"operationType": @(operationType)}];
            [_quickLoginPhoneCodeTimer invalidate];
            _quickLoginPhoneCodeTimer = nil;
            _quickLoginPhoneCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:[MARWeakProxy proxyWithTarget:self] selector:@selector(phoneCodeCountDown:) userInfo:userInfo repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_quickLoginPhoneCodeTimer forMode:NSRunLoopCommonModes];
        }
            break;
        case MARPhoneOperationTypeBind:
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone?:@"", @"count": @(60), @"operationType": @(operationType)}];
            [_bindPhoneCodeTimer invalidate];
            _bindPhoneCodeTimer = nil;
            _bindPhoneCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:[MARWeakProxy proxyWithTarget:self] selector:@selector(phoneCodeCountDown:) userInfo:userInfo repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_bindPhoneCodeTimer forMode:NSRunLoopCommonModes];
        }
            break;
        case MARPhoneOperationTypeSetPassword:
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":phone?:@"", @"count": @(60), @"operationType": @(operationType)}];
            [_setPasswordPhoneCodeTimer invalidate];
            _setPasswordPhoneCodeTimer = nil;
            _setPasswordPhoneCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:[MARWeakProxy proxyWithTarget:self] selector:@selector(phoneCodeCountDown:) userInfo:userInfo repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_setPasswordPhoneCodeTimer forMode:NSRunLoopCommonModes];
        }
            break;
    }
}

- (void)phoneCodeCountDown:(NSTimer *)timer
{
    NSMutableDictionary *userInfo = timer.userInfo;
    if ([userInfo[@"count"] integerValue] > 0) {
        userInfo[@"count"] = @([userInfo[@"count"] integerValue] - 1);
        [MARGLOBALMANAGER postNotif:kMARNotificationType_PhoneCodeCount data:userInfo object:nil];
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)calculateVideoCacheSizeWithCompletionBlock:(MARCalculateSizeBlock)completionBlock {
    [self calculateSizeWithFolderPath:[self videoDiskPath] completionBlock:completionBlock];
}

- (void)calculateImgCacheSizeWithCompletionBlock:(MARCalculateSizeBlock)completionBlock
{
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:completionBlock];
}

- (void)calculateSizeWithFolderPath:(NSString *)filePath
                    completionBlock:(MARCalculateSizeBlock)completionBlock
{
    NSString *videoDiskCachePath = filePath;
    NSURL *diskCacheURL = [NSURL fileURLWithPath:videoDiskCachePath isDirectory:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:diskCacheURL
                                                                     includingPropertiesForKeys:@[NSFileSize]
                                                                                        options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                   errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}

- (void)clearImgDiskOnCompletion:(void (^)(void))completion
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:completion];
}

- (NSString *)videoDiskPath
{
    return [KTVHCPathTools absolutePathWithRelativePath:@"KTVHTTPCache"];
}

- (void)clearVideoDiskOnCompletion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *folderPath = [self videoDiskPath];
        if (folderPath.length <= 0) {
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
            return;
        }
        NSError * error = nil;
        BOOL isDirectory = NO;
        BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
        if (result && isDirectory) {
            result = [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error];
        }
        if (isDirectory) {
            [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error];
        }
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (NSString *)briefTimeStrWithDate:(NSDate *)date
{
    return [date mar_timeInWords];
}

- (NSString *)briefTimeStrWithDateStr:(NSString *)dateStr
{
    NSDate *date = MARNSDateParseFromString(dateStr);
    return [date mar_timeInWords];
}

// 第一次开启app调用的方法
- (void)firstStartApp
{
    NSLog(@"第一次启动app");
    // 第一次启动,城市天气自动显示北京
    MAAWeatherLocalCityModel *beijingCity = [MAAWeatherLocalCityModel new];
    beijingCity.cityid = @"1";
    beijingCity.citycode = @"101010100";
    beijingCity.city = @"北京";
    beijingCity.parentid = @"0";
    [beijingCity updateToDB];
}

// 升级后第一次开启app调用的方法
- (void)firstStartAppAfterUpdate
{
    NSLog(@"第一次调用app 升级后第一次开启app调用的方法");
}

// 启动app调用的方法
- (void)startApp
{
    NSLog(@"启动app调用的方法");
}

@end
