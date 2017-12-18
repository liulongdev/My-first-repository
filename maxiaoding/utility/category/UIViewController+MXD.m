//
//  UIViewController+MXD.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

/// 用到的宏
#ifndef MARAssert
#define MARAssert(a,s, ...) NSAssert(!(a), @"%s [Line %d] %@", __PRETTY_FUNCTION__, __LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__] );
#endif

#import "UIViewController+MXD.h"

@implementation UIViewController (MXD)

+ (instancetype)vcWithStoryboardName:(NSString *)name storyboardId:(NSString *)storyboardId
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    if (storyboard) {
        MARAssert(!storyboard, @"Storyboard<name :'%@'> is not exist", name);
    }
    return [storyboard instantiateViewControllerWithIdentifier:storyboardId];
}



@end
