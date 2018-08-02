//
//  MARHomeTestVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeTestVC.h"
#import "MARHomeDateView.h"
#import "MARHomeVC.h"
#import <iCarousel.h>
#import "MARCitiesWeatherVC.h"
#import "MAACarBrandListVC.h"
#import "MARWYVideoNewVC.h"
#import "MARCookCategoryCollectionVC.h"
#import "MARHomeSettingVC.h"

@interface MARHomeTestVC () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UIView *timeInfoView;
@property (nonatomic, strong) UIView *weatherView;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) UIView *wyVideoView;
@property (nonatomic, strong) UIView *cookView;
@property (nonatomic, strong) UIView *settingView;

@property (nonatomic, strong) NSArray *viewArray;
@end

@implementation MARHomeTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
//    self.view.backgroundColor = [UIColor yellowColor];
    //create carousel
    _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSNumber *typeNum = [MARUserDefault getNumberBy:USERDEFAULTKEY_HomeStyle];
    if (typeNum) {
        _carousel.type = [typeNum integerValue];
    }
    else
        _carousel.type = iCarouselTypeCoverFlow;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    
    //add carousel to view
    [self.view addSubview:_carousel];

}

- (void)UIGlobal
{
    
}

- (NSArray *)viewArray
{
    if (!_viewArray) {
        _viewArray = @[self.timeInfoView,
                       self.weatherView,
                       self.carView,
                       self.wyVideoView,
                       self.cookView,
                       self.settingView
                       ];
    }
    return _viewArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.viewArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index < self.viewArray.count) {
        view = self.viewArray[index];
    }
    double pageScale = [MARUserDefault getDoubleBy:USERDEFAULTKEY_HomePageScale];
    if (pageScale <0.5 || pageScale > 1) {
        pageScale = 1;
    }
    view.frame = CGRectMake(0, 0, kScreenWIDTH * pageScale, kScreenHEIGHT * pageScale);
    return view;
}

- (UIView *)timeInfoView
{
    if (!_timeInfoView) {
        MARHomeVC *homeVC = [[MARHomeVC alloc] init];
        [self addChildViewController:homeVC];
        _timeInfoView = homeVC.view;
        
//        _timeInfoView = [MARHomeDateView nibView];
//        _timeInfoView.backgroundColor = RGBHEX(0x99ccff);
    }
    return _timeInfoView;
}

- (UIView *)weatherView
{
    if (!_weatherView) {
        MARCitiesWeatherVC *weatherVC = [[MARCitiesWeatherVC alloc] init];
        weatherVC.isHomeStyle = YES;
        [self addChildViewController:weatherVC];
        _weatherView = weatherVC.view;
    }
    return _weatherView;
}

- (UIView *)carView
{
    if (!_carView) {
        MAACarBrandListVC *carVC = (MAACarBrandListVC *)[UIViewController vcWithStoryboardName:kSBNAME_Car storyboardId:kSBID_Car_CarBrandListVC];
        carVC.isHomeStyle = YES;
        [self addChildViewController:carVC];
        _carView = carVC.view;
    }
    return _carView;
}

- (UIView *)wyVideoView
{
    if (!_wyVideoView) {
        MARWYVideoNewVC *wyVideoVC = [[MARWYVideoNewVC alloc] init];
        wyVideoVC.isHomeStyle = YES;
        [self addChildViewController:wyVideoVC];
        _wyVideoView = wyVideoVC.view;
    }
    return _wyVideoView;
}

- (UIView *)cookView
{
    if (!_cookView) {
        MARCookCategoryCollectionVC *cookListVC = (MARCookCategoryCollectionVC *)[UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_CookCategoryCollectionVC];
        [self addChildViewController:cookListVC];
        _cookView = cookListVC.view;
    }
    return _cookView;
}

- (UIView *)settingView
{
    if (!_settingView) {
        MARHomeSettingVC *settingVC = (MARHomeSettingVC *)[UIViewController vcWithStoryboardName:kSBNAME_Setting storyboardId:kSBID_Setting_HomeSettingVC];
        [self addChildViewController:settingVC];
        _settingView = settingVC.view;
    }
    return _settingView;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (carousel.currentItemIndex != [self.viewArray indexOfObject:self.wyVideoView]) {
        [MARGLOBALMANAGER postNotif:kMARNotificationType_CloseWYVideoPlay data:nil object:nil];
    }
    if (carousel.currentItemIndex == self.viewArray.count - 1) {
        [MARGLOBALMANAGER postNotif:kMARNotificationType_CaculateCache data:nil object:nil];
    }
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    if (type == kMARNotificationType_ChooseHomeStyle) {
        NSNumber *typeNum = [MARUserDefault getNumberBy:USERDEFAULTKEY_HomeStyle];
        if (typeNum && [typeNum isEqual:data]) {
            return;
        }
        [MARUserDefault setNumber:data key:USERDEFAULTKEY_HomeStyle];
        [UIView beginAnimations:nil context:nil];
        self.carousel.type = [data integerValue];
        [UIView commitAnimations];
        
        [self.carousel reloadData];
    }
    else if (type == kMARNotificationType_NeedReloadHomeMagicView)
    {
        [self.carousel reloadData];
    }
    else if (type == kMARNotificationType_MARWYVideoStatusChanged)
    {
        // 如果当前正在播放视频的时候不可滑动    MARVideoStatusPlaying
        if ([data integerValue] == 1) {
            if ([[self currentViewController] isKindOfClass:[MARWYVideoNewVC class]]) {
                self.carousel.scrollEnabled = NO;
            }
        }
        else
        {
            if (!self.carousel.scrollEnabled) {
                self.carousel.scrollEnabled = YES;
            }
        }
    }
}

- (UIViewController *)currentViewController
{
    // timeinfo 不是controller
    if (self.childViewControllers.count > self.carousel.currentItemIndex && self.carousel.currentItemIndex > 0)
    {
        return self.childViewControllers[self.carousel.currentItemIndex];
    }
    return nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *vc = [self currentViewController];
    if (vc) {
        return [vc preferredStatusBarStyle];
    }
    else
        return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    UIViewController *vc = [self currentViewController];
    if (vc) {
        return [vc prefersStatusBarHidden];
    }
    else
        return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    UIViewController *vc = [self currentViewController];
    if (vc) {
        return [vc preferredStatusBarUpdateAnimation];
    }
    else
        return UIStatusBarAnimationFade;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIViewController *)currentViewController
{
    // timeinfo 不是controller
    if (self.childViewControllers.count > self.carousel.currentItemIndex && self.carousel.currentItemIndex > 0)
    {
        return self.childViewControllers[self.carousel.currentItemIndex];
    }
    return nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *vc = [self currentViewController];
    if (vc) {
        return [vc preferredStatusBarStyle];
    }
    else
        return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    UIViewController *vc = [self currentViewController];
    if (vc) {
        return [vc prefersStatusBarHidden];
    }
    else
        return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    UIViewController *vc = [self currentViewController];
    if (vc) {
        return [vc preferredStatusBarUpdateAnimation];
    }
    else
        return UIStatusBarAnimationFade;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
