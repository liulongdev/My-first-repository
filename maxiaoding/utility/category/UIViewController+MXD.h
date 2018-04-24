//
//  UIViewController+MXD.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MXD)

+ (instancetype) vcWithStoryboardName:(NSString *)name storyboardId:(NSString *)storyboardId;

@property (nonatomic, readonly) BOOL mar_isSupportForceTouch;

@end
