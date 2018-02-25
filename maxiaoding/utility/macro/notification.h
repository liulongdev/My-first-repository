//
//  notification.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#ifndef notification_h
#define notification_h

#define kMARGlobalNotification          @"kMARGlobalNotification"
#define kMARGlobalLocalNotification     @"kMARGlobalLocalNotification"

#define KMARUIApplicationDidBecomeActiveNotification @"KMARUIApplicationDidBecomeActiveNotification"
#define kMARUIApplicationDidEnterBackgroundNotification @"kMARUIApplicationDidEnterBackgroundNotification"


typedef NS_ENUM(NSInteger, kMARNotificationType) {
    kMARNotificationType_NetworkChangedEnabel,
    kMARNotificationType_NetworkChangedDisEnabel,
    kMARNotificationType_PhoneCodeCount = 1,        // 手机获取验证码倒计时通知
    kMARNotificationType_MARWYVideoStatusChanged,   // 视频状态改变通知
    kMARNotificationType_ClickAppStatusBar,         // 点击头部
    kMARNotificationType_CloseWYVideoPlay,          // 关闭网易视频
    kMARNotificationType_ChooseHomeStyle,           // 选择首页样式
    kMARNotificationType_NeedReloadHomeMagicView,   // 需要重新加载首页控件 设置页面比例
};


#endif /* notification_h */
