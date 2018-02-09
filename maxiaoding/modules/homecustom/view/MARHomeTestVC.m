//
//  MARHomeTestVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeTestVC.h"
#import "MARHomeDateView.h"
#import <iCarousel.h>
#import "MARWeatherVC.h"
#import "MARCarBrandListVC.h"
@interface MARHomeTestVC () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UIView *weatherView;
@property (nonatomic, strong) UIView *carView;
@end

@implementation MARHomeTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
//    self.view.backgroundColor = [UIColor yellowColor];
    //create carousel
    _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = iCarouselTypeCoverFlow2;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    
    //add carousel to view
    [self.view addSubview:_carousel];

}

- (void)UIGlobal
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (index == 0) {
        if ([view isKindOfClass:[MARHomeDateView class]])
        {
            
        }
        else
        {
            view = [MARHomeDateView nibView];
            view.backgroundColor = RGBHEX(0x99ccff);
        }
    }
    if (index == 1) {
        view = self.weatherView;
    }
    if (index == 2) {
        view = self.carView;
    }
    view.frame = CGRectMake(0, 0, kScreenWIDTH, kScreenHEIGHT);
    return view;
}

- (UIView *)weatherView
{
    if (!_weatherView) {
        MARWeatherVC *weatherVC = (MARWeatherVC *)[UIViewController vcWithStoryboardName:kSBNAME_Weather storyboardId:kSBID_Weather_WeatherVC];
        [self addChildViewController:weatherVC];
        _weatherView = weatherVC.view;
    }
    return _weatherView;
}

- (UIView *)carView
{
    if (!_carView) {
        MARCarBrandListVC *carVC = (MARCarBrandListVC *)[UIViewController vcWithStoryboardName:kSBNAME_Car storyboardId:kSBID_Car_CarBrandListVC];
        [self addChildViewController:carVC];
        _carView = carVC.view;
    }
    return _carView;
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

@end
