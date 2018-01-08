//
//  UIScrollView+MXD.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/7.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "UIScrollView+MXD.h"
#import <objc/runtime.h>
static char fd_popGestureEnabledKey;
@implementation UIScrollView (MXD)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0 && self.fd_popGestureEnabled) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)fd_popGestureEnabled
{
    return [objc_getAssociatedObject(self, &fd_popGestureEnabledKey) boolValue];
}

- (void)setFd_popGestureEnabled:(BOOL)fd_popGestureEnabled
{
    objc_setAssociatedObject(self, &fd_popGestureEnabledKey, @(fd_popGestureEnabled), OBJC_ASSOCIATION_ASSIGN);
}

@end
