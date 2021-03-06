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
    UIViewController *VC = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    if (!VC) {
        MARErrorLog(@">>>> error  VC is not found whose name is %@ from %@ storyboard", name, storyboard);
    }
    return VC;
}

- (BOOL)mar_isSupportForceTouch
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.f) {
        return self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
#pragma clang diagnostic pop
    }
    return NO;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
- (id<UIViewControllerPreviewing>)mar_registerForPreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView
{
    if (sourceView && [self mar_isSupportForceTouch]) {
        return [self registerForPreviewingWithDelegate:delegate sourceView:sourceView];
    }
#pragma clang diagnostic pop
    return nil;
}


@end
