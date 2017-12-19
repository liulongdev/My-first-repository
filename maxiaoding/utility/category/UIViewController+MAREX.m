//
//  UIViewController+MAREX.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/18.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "UIViewController+MAREX.h"
#import <NSObject+MAREX.h>
#import <objc/runtime.h>
static char mar_prePageNameKey;
static char mar_pageAppearTimeIntervalKey;
static char mar_enterBackGroundTimeIntervalKey;
static char mar_preferredNavigationBarHiddenKey;
static char mar_naviBackPanGestureEnabelKey;

@implementation UIViewController (MAREX)
+(void)load
{
    [self mar_swizzleInstanceMethod:@selector(viewDidAppear:) with:@selector(mar_viewDidAppear:)];
    [self mar_swizzleInstanceMethod:@selector(viewDidDisappear:) with:@selector(mar_viewDidDisappear:)];
    [self mar_swizzleInstanceMethod:@selector(prepareForSegue:sender:) with:@selector(mar_prepareForSegue:sender:)];
    [self mar_swizzleInstanceMethod:@selector(viewWillAppear:) with:@selector(mar_viewWillAppear:)];
    
}

- (void)mar_viewWillAppear:(BOOL)animated
{
    [self mar_viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.mar_preferredNavigationBarHidden animated:YES];
    if (!self.mar_preferredNavigationBarHidden || self.mar_naviBackPanGestureEnabel) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    }
    
    if (!self.mar_naviBackPanGestureEnabel) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

    
}

- (void)mar_viewDidAppear:(BOOL)animated
{
    [self mar_viewDidAppear:animated];
    [self ex_marAddObserservs];
    self.mar_pageAppearTimeInterval = [NSDate new].timeIntervalSince1970;
    [MARDataAnalysis pageAppear:self];
}

- (void)mar_viewDidDisappear:(BOOL)animated
{
    [self mar_viewDidDisappear:animated];
    [self ex_marRemoveObservers];
    [MARDataAnalysis pageDisAppear:self];
    if (self.mar_pageAppearTimeInterval > 0) {
        NSTimeInterval durationOnPage = (long long)[NSDate new].timeIntervalSince1970 - self.mar_pageAppearTimeInterval;
        if (durationOnPage > 0) {
            [MARDataAnalysis setSourcePageName:self.mar_prePageName destinationPagename:self.mar_currentPageName durationOnPage:durationOnPage];
        }
    }
    else
    {
        [MARDataAnalysis setSourcePageName:self.mar_prePageName destinationPagename:self.mar_currentPageName];
    }
}

- (void)mar_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *sourceVC = segue.sourceViewController;
    sourceVC.mar_prePageName = sourceVC.mar_currentPageName;
}

- (void)mar_pushViewController:(UIViewController *)VC animated:(BOOL)animated
{
    VC.mar_prePageName = self.mar_currentPageName;
    [self.navigationController pushViewController:VC animated:animated];
}


- (long long)mar_pageAppearTimeInterval
{
    return [objc_getAssociatedObject(self, &mar_pageAppearTimeIntervalKey) longLongValue];
}

- (void)setMar_pageAppearTimeInterval:(long long)mar_pageAppearTimeInterval
{
    objc_setAssociatedObject(self, &mar_pageAppearTimeIntervalKey, @((long long)mar_pageAppearTimeInterval), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)mar_prePageName
{
    return objc_getAssociatedObject(self, &mar_prePageNameKey);
}

- (void)setMar_prePageName:(NSString *)mar_prePageName
{
    objc_setAssociatedObject(self, &mar_prePageNameKey, mar_prePageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (long long)mar_enterBackGroundTimeInterval
{
    return [objc_getAssociatedObject(self, &mar_enterBackGroundTimeIntervalKey) longLongValue];
}

- (void)setMar_enterBackGroundTimeInterval:(long long)mar_enterBackGroundTimeInterval
{
    objc_setAssociatedObject(self, &mar_enterBackGroundTimeIntervalKey, @((long long)mar_enterBackGroundTimeInterval), OBJC_ASSOCIATION_ASSIGN);
}


-(NSString *)mar_currentPageName
{
    NSString *pageClassStr = NSStringFromClass(self.class);
    return [pageClassStr stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
}

//#define MARVCEXNOTIFICATION_DEFAULT
#ifdef MARVCEXNOTIFICATION_DEFAULT
#define NOTIFICATION_APPDidBecomeActive KMARUIApplicationDidBecomeActiveNotification
#define NOTIFICATION_APPDidEnterBackGround kMARUIApplicationDidEnterBackgroundNotification
#else
#define NOTIFICATION_APPDidBecomeActive UIApplicationDidBecomeActiveNotification
#define NOTIFICATION_APPDidEnterBackGround UIApplicationDidEnterBackgroundNotification
#endif
- (void)ex_marAddObserservs
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_refreshPageAppearTimeInterval:) name:NOTIFICATION_APPDidBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_setEnterBackGoundTimeInterval:) name:kMARUIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)ex_marRemoveObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_APPDidBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMARUIApplicationDidEnterBackgroundNotification object:nil];
}
#undef NOTIFICATION_APPDidBecomeActive
#undef NOTIFICATION_APPDidEnterBackGround

- (void)_setEnterBackGoundTimeInterval:(NSNotification *)noti
{
    self.mar_enterBackGroundTimeInterval = (long long)[[NSDate new] timeIntervalSince1970];
}

/**
 刷新最新间隔时间，避免因为进入后台而导致的时间不准确
 */
- (void)_refreshPageAppearTimeInterval:(NSNotification *)noti
{
    if (self.mar_pageAppearTimeInterval > 0) {
        if (self.mar_enterBackGroundTimeInterval > self.mar_pageAppearTimeInterval) {
            self.mar_pageAppearTimeInterval = (long long)[NSDate new].timeIntervalSince1970 - (self.mar_enterBackGroundTimeInterval - self.mar_pageAppearTimeInterval);
        }
        else
            self.mar_pageAppearTimeInterval = (long long)[NSDate new].timeIntervalSince1970;
    }
}

/**
 NavigationControler
 */
- (BOOL)mar_preferredNavigationBarHidden
{
    return [objc_getAssociatedObject(self, &mar_preferredNavigationBarHiddenKey) boolValue];
}

- (void)setMar_preferredNavigationBarHidden:(BOOL)mar_preferredNavigationBarHidden
{
    objc_setAssociatedObject(self, &mar_preferredNavigationBarHiddenKey, @(mar_preferredNavigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)mar_naviBackPanGestureEnabel
{
    return ![objc_getAssociatedObject(self, &mar_naviBackPanGestureEnabelKey) boolValue];
}

- (void)setMar_naviBackPanGestureEnabel:(BOOL)mar_naviBackPanGestureEnabel
{
    objc_setAssociatedObject(self, &mar_naviBackPanGestureEnabelKey, @(!mar_naviBackPanGestureEnabel), OBJC_ASSOCIATION_ASSIGN);
}

@end
