//
//  MARAppDelegate.m
//  
//
//  Created by Martin.Liu on 15/12/21.
//  Copyright © 2015年 MAR. All rights reserved.
//

#import "MARAppDelegate.h"
#import <RealReachability.h>
//#import "NotificationMacro.h"
//#import "AppMacro.h"
//#import "css.h"

@implementation MARAppDelegate

-(void)startMonitorNetwork
{
    //开启网络状况的监听  RealReachability 替代
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];
//    Reachability * reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    [reach startNotifier];
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

- (void) stopMonitorNetwork
{
    [GLobalRealReachability stopNotifier];
}

- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    
//    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status)
        {
            case RealStatusNotReachable:
            {
                //  case NotReachable handler
                [MARGLOBALMANAGER postNotif:kMARNotificationType_NetworkChangedDisEnabel data:nil object:nil];
                break;
            }
                
            case RealStatusViaWiFi:
            {
                [MARGLOBALMANAGER postNotif:kMARNotificationType_NetworkChangedEnabel data:nil object:nil];
                //  case ReachableViaWiFi handler
                break;
            }
                
            case RealStatusViaWWAN:
            {
                [MARGLOBALMANAGER postNotif:kMARNotificationType_NetworkChangedEnabel data:nil object:nil];
                //  case ReachableViaWWAN handler
                break;
            }
                
            default:
                break;
        }
//    }];
//    // 获取当前的数据网络连接类型
//    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
//    switch (accessType) {
//        case WWANType2G:
//            
//            break;
//        case WWANType3G:
//            
//            break;
//        case WWANType4G:
//            
//            break;
//        default:
//            break;
//    }
}
// RealReachability 替代
//- (void) reachabilityChanged: (NSNotification* )noti
//{
//    Reachability* curReach = [noti object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    GLOBALMANAGER.currentNetWork = curReach.currentReachabilityStatus;
//    // 发送网络改变通知
//    [GLOBALMANAGER postNotif:kMARNotification_ReachabilityChanged data:nil object:nil];
//}
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
