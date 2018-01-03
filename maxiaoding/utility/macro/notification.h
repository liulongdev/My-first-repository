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
    kMARNotificationType_PhoneCodeCount = 1,
};


#endif /* notification_h */
