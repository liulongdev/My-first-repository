//
//  MARAppDelegate.m
//  
//
//  Created by Martin.Liu on 15/12/21.
//  Copyright © 2015年 MAR. All rights reserved.
//

#import "MARAppDelegate.h"

@implementation MARAppDelegate

-(void)startMonitorNetwork
{
    [MARGLOBALMANAGER setNotifyChangeNetStatusForKey:@"MARAppMonitor" block:^(MARReachabilityNetStatus reachabilityNetStatus) {
        switch (reachabilityNetStatus) {
            case MARReachabilityNetStatusWIFI:
            case MARReachabilityNetStatusWAN2G:
            case MARReachabilityNetStatusWAN3G:
            case MARReachabilityNetStatusWAN4G:
            case MARReachabilityNetStatusWAN:
                [MARGLOBALMANAGER postNotif:kMARNotificationType_NetworkChangedEnabel data:nil object:nil];
                break;
            case MARReachabilityNetStatusNotReachbale:
                [MARGLOBALMANAGER postNotif:kMARNotificationType_NetworkChangedDisEnabel data:nil object:nil];
                break;
        }
    }];
}

- (void) stopMonitorNetwork
{
    [MARGLOBALMANAGER setNotifyChangeNetStatusForKey:@"MARAppMonitor" block:nil];
}

#pragma mark - 注册推送通知
#pragma mark 申请DeviceToken
- (void)registerDeviceToken
{
//#ifdef __IPHONE_8_0
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
////        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
////        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }  else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
//#else
//    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken
{
    NSString *devStr = [NSString stringWithFormat:@"%@",_deviceToken];
    NSArray *array = [devStr componentsSeparatedByString:@" "];
    NSString* deviceToken = [array componentsJoinedByString:@""];
    deviceToken = [deviceToken substringWithRange:NSMakeRange(1, deviceToken.length - 2)];
    MARLog(@"device token : %@", deviceToken);
}

- (void)initAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(APPNaviBarTint, 1)];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(APPNaviTint, 1)];
    [UINavigationBar appearance].translucent = YES;
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:RGBHEX(APPNaviTint), NSForegroundColorAttributeName, [UIFont systemFontOfSize:kSCALE(15.f)], NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,UIColorFromRGB(APPNaviBarTint, 1).CGColor);
    CGContextFillRect(context, rect);
    UIImage * imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [[UINavigationBar appearance] setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    if (@available(iOS 11.0, *)){//避免滚动视图顶部出现多余空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
}

- (void)initUMShare
{
    /* 打开调试日志 */
#ifdef DEBUG
    [[UMSocialManager defaultManager] openLog:YES];
#endif
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMSHARE_AppKey];
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WechatAppKey appSecret:WechatAppSecretKey redirectURL:nil];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINAAppKey  appSecret:SINAAppSecretKey redirectURL:@"https://api.weibo.com/oauth2/default.html"];
}

- (void)confitUShareSettings
{
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    //创建图片水印配置类
    UMSocialImageWarterMarkConfig* imageWarterMarkConfig= [[UMSocialImageWarterMarkConfig alloc] init];
    NSString *markString = @"马小丁-Martin";
    CGSize markStrSize = [markString boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont mar_fontForFontName:MARFontNameHelvetica size:10.f], } context:nil].size;
    imageWarterMarkConfig.warterMarkImage = [[UIImage mar_imageFromText:markString font:MARFontNameHelvetica fontSize:10.f imageSize:markStrSize] mar_imageByTintColor:RGBHEX(0x4876FF)];
    imageWarterMarkConfig.warterMarkImageAlpha = 0.5;
    imageWarterMarkConfig.warterMarkImageScale = 0.3;
    imageWarterMarkConfig.paddingToHorizontalParentBorder = 5;
    imageWarterMarkConfig.paddingToVerticalParentBorder = 5;
    //创建水印配置类
    UMSocialWarterMarkConfig* warterMarkConfig = [[UMSocialWarterMarkConfig alloc] init];
    warterMarkConfig.stringAndImageWarterMarkPositon = UMSocialImageWarterMarkBottomRight;
    [warterMarkConfig setUserDefinedImageWarterMarkConfig:imageWarterMarkConfig];
    
    //设置水印配置类
    [UMSocialGlobal shareInstance].warterMarkConfig = warterMarkConfig;
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)mar_begingBackgoundTask
{
    self.backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self mar_endBackgroundTask];
    }];
    MARLog(@"\n\n\n\n >>>> %ld", self.backgroundIdentifier);
}

- (void)mar_endBackgroundTask
{
    if (self.backgroundIdentifier != UIBackgroundTaskInvalid) {    
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
        self.backgroundIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
