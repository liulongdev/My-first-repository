//
//  macro.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#ifndef macro_h
#define macro_h

#import "css.h"
#import "appkey.h"
#import "enum.h"
#import "notification.h"
#import "userdefaultkey.h"


#import "UIViewController+MXD.h"
#import "UIImageView+SDWEBEXT.h"
#import "MARSBConstant.h"

#endif /* macro_h */

#ifndef MARSTRWITHINT
#define MARSTRWITHINT(_value) [NSString stringWithFormat:@"%ld", (long)_value]
#endif

#ifndef MARCONTENTINSETTOP
#define MARCONTENTINSETTOP(_vc) \
            [UIApplication sharedApplication].statusBarFrame.size.height \
            + _vc.navigationController.navigationBar.frame.size.height
#endif
