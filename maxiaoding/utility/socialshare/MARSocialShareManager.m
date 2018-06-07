//
//  MARSocialShareManager.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/7.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARSocialShareManager.h"
#import <UShareUI/UShareUI.h>
#import "AppDelegate.h"
@implementation MARSocialShareManager

+ (void)setSupportPlatforms
{
    [UMSocialUIManager setPreDefinePlatforms:[[UMSocialManager defaultManager] platformTypeArray]];
}

+ (void)setPreDefinePlatforms:(NSArray *)preDefinePlatforms
{
//    [self setSupportPlatforms];
    [UMSocialUIManager setPreDefinePlatforms:preDefinePlatforms];
}

+(void)showShareMenuViewInWindowWithMessage:(MARSocialShareMessageModel *)message complete:(MARSocialRequestCompletionHandler)complete
{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

        switch (message.messageType) {
            case MARSocialShareMessageType_URL:
            {
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:message.title descr:message.shareDesc thumImage:message.thumImage];
                //设置网页地址
                shareObject.webpageUrl = message.URLString;
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
            }
                break;
            case MARSocialShareMessageType_VideoURL:
            {
                UMShareVideoObject *shareObjc = [UMShareVideoObject shareObjectWithTitle:message.title descr:message.shareDesc thumImage:message.thumImage];
                //设置网页地址
                shareObjc.videoUrl = message.URLString;
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObjc;
            }
                break;
            case MARSocialShareMessageType_Image:
            {
                UMShareImageObject *shareObjc = [UMShareImageObject shareObjectWithTitle:message.title descr:message.shareDesc thumImage:message.thumImage];
                shareObjc.shareImage = message.image;
                messageObject.shareObject = shareObjc;
            }
                break;
            default:
                ShowErrorMessage(@"该内容无法分享", 1.5f);
                return;
                break;
        }
        
        UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = [(UINavigationController *)topVC topViewController];
        }
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:topVC completion:^(id result, NSError *error) {
            if (complete) {
                complete(result, error);
                return;
            }
            if (error) {
                ShowErrorMessage(@"分享失败!", 1.5);
                return;
            }
            NSString *msg = @"分享成功";
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
               
                if ([(UMSocialShareResponse *)result message].length > 0) {
                    msg = [(UMSocialShareResponse *)result message];
                }
            }
            ShowSuccessMessage(msg, 2.f);
        }];
    }];
}

@end

@implementation MARSocialShareMessageModel

@end
