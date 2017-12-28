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
#import "request.h"

#import "UIViewController+MXD.h"
#import "UIImageView+SDWEBEXT.h"
#import "MARSBConstant.h"

#endif /* macro_h */

#ifndef MARSTRWITHINT
#define MARSTRWITHINT(_value) [NSString stringWithFormat:@"%ld", (long)_value]
#endif

#ifndef MARCONTENTINSETTOP
#define MARCONTENTINSETTOP(_vc) \
            ([UIApplication sharedApplication].statusBarFrame.size.height \
            + _vc.navigationController.navigationBar.frame.size.height)
#endif


#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
        #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __strong __typeof__(object) strong##_##object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
        #else
            #if __has_feature(objc_arc)
                #define strongify(object) try{} @finally{} __strong __typeof__(object) strong##_##object = weak##_##object;
            #else
                #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif
