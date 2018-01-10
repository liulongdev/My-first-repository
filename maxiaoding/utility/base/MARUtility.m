//
//  MARUtility.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARUtility.h"
#import <KTVHCPathTools.h>

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

@end
