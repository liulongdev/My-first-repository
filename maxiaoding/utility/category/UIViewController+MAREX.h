//
//  UIViewController+MAREX.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/18.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MAREX)

@property (nonatomic, strong) NSString *mar_prePageName;        // 上一级跳转的页面名称
@property (nonatomic, assign) long long mar_pageAppearTimeInterval;
@property (nonatomic, assign) long long mar_enterBackGroundTimeInterval;

- (void)mar_pushViewController:(UIViewController *)VC animated:(BOOL)animated;

@property (nonatomic, readonly) NSString *mar_currentPageName;

/**
 *  YES will call [self.navigationController setNavigationBarHidden:NO animated:YES] when view will appeal,
 *  NO do nothing
 */
@property (nonatomic, assign) BOOL mar_preferredNavigationBarHidden;

@property (nonatomic, assign) BOOL mar_naviBackPanGestureEnabel;

@end
