//
//  MARCitiesWeatherVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/7.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARCitiesWeatherVC.h"
#import <VTMagic.h>
#import "MARWeatherVC.h"
#import "MAAWeatherModel.h"
#import <Masonry.h>
#import "UIScrollView+MXD.h"
#import "MARWeatherChooseCityVC.h"
@interface MARCitiesWeatherVC () <VTMagicViewDelegate, VTMagicViewDataSource>
@property (nonatomic, strong) VTMagicController *magicController;

@property (nonatomic, strong) NSArray<MAAWeatherLocalCityModel *> *cityArray;
@property (nonatomic, strong) NSMutableArray *cityTitleArray;

@property (nonatomic, strong) UIButton *additionCityButton;
@property (nonatomic, strong) UIButton *removeCityButton;

@end

@implementation MARCitiesWeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [_magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    UIScrollView *scrollView = [_magicController.magicView valueForKey:@"contentView"];
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        scrollView.fd_popGestureEnabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cityArray];
}

- (void)UIGlobal
{
    UIBarButtonItem *rightAddBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:nil action:nil];
    @weakify(self)
    [rightAddBarBtn setMar_actionBlock:^(id sender) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self gotoChooseCityVC];
    }];
    
    UIBarButtonItem *rightRemoveBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"-" style:UIBarButtonItemStyleDone target:nil action:nil];
    [rightRemoveBarBtn setMar_actionBlock:^(id sender) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self removeCurrentCityWeather];
    }];
    
    UIBarButtonItem *fixBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBarButton.width = 30;
    
    self.navigationItem.rightBarButtonItems = @[rightAddBarBtn, fixBarButton, rightRemoveBarBtn];
}

- (void)gotoChooseCityVC
{
    MARWeatherChooseCityVC *chooseCityVC = (MARWeatherChooseCityVC *)[UIViewController vcWithStoryboardName:kSBNAME_Weather storyboardId:kSBID_Weather_WeatherChooseCityVC];
    chooseCityVC.selectLoalCityMBlock = ^(MAAWeatherLocalCityModel *localCityM) {
        self.cityArray = nil;
        NSArray* cityArray = [self cityArray];
        NSInteger pageIndex = [cityArray indexOfObject:localCityM];
        [self.magicController switchToPage:pageIndex animated:NO];
    };
    [self mar_pushViewController:chooseCityVC animated:YES];
}

- (void)removeCurrentCityWeather
{
    if (self.cityArray.count > 1 && self.cityArray.count > self.magicController.currentPage) {
        BOOL deleteFlag = [self.cityArray[self.magicController.currentPage] deleteToDB];
        if (deleteFlag) {
            self.cityArray = nil;
            [self cityArray];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        if (self.isHomeStyle) {
            _magicController.magicView.scrollEnabled = NO;
            UIView *naviRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            naviRightView.backgroundColor = [UIColor clearColor];
            _magicController.magicView.rightNavigatoinItem = naviRightView;
            [naviRightView addSubview:self.additionCityButton];
            [naviRightView addSubview:self.removeCityButton];
            [self.removeCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(naviRightView);
                make.leading.mas_equalTo(naviRightView);
                make.size.mas_equalTo(CGSizeMake(50, 44));
            }];
            [self.additionCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(naviRightView);
                make.leading.mas_equalTo(self.removeCityButton.mas_trailing);
                make.size.mas_equalTo(self.removeCityButton);
            }];
        }
        else
        {
            _magicController.magicView.navigationHeight = 0.f;
        }
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.itemScale = 1.2;
        //        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
    }
    return _magicController;
}

- (NSArray<MAAWeatherLocalCityModel *> *)cityArray
{
    if (!_cityArray) {
        _cityArray = (NSArray<MAAWeatherLocalCityModel *> *)[MAAWeatherLocalCityModel cityArrayWhere:nil];
        [_cityTitleArray removeAllObjects];
        for (MAAWeatherLocalCityModel *model in _cityArray) {
            [self.cityTitleArray addObject:model.city ?: @""];
        }
        [self.magicController.magicView reloadData];
    }
    return _cityArray;
}

- (NSMutableArray *)cityTitleArray
{
    if (!_cityTitleArray) {
        _cityTitleArray = [NSMutableArray array];
    }
    return _cityTitleArray;
}

- (UIButton *)additionCityButton
{
    if (!_additionCityButton) {
        _additionCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_additionCityButton setTitle:@"+" forState:UIControlStateNormal];
        [_additionCityButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        @weakify(self)
        [_additionCityButton mar_addActionBlock:^(id sender) {
            @strongify(self)
            if (!strong_self) return;
            [MARDataAnalysis setEventPage:@"citiesWeatherVC" EventLabel:@"weather_click_add_city"];
            [strong_self gotoChooseCityVC];
        } forState:UIControlEventTouchUpInside];
    }
    return _additionCityButton;
}

- (UIButton *)removeCityButton
{
    if (!_removeCityButton) {
        _removeCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeCityButton setTitle:@"-" forState:UIControlStateNormal];
        [_removeCityButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        @weakify(self)
        [_removeCityButton mar_addActionBlock:^(id sender) {
            @strongify(self)
            if (!strong_self) return;
            [MARDataAnalysis setEventPage:@"citiesWeatherVC" EventLabel:@"weather_click_remove_city"];
            [strong_self removeCurrentCityWeather];
        } forState:UIControlEventTouchUpInside];
    }
    return _removeCityButton;
}

- (void)dealloc
{
    [_additionCityButton mar_removeAllActionBlocks];
}

#pragma mark - VCMagicController Datasource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.cityTitleArray;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *vcIdentifier = @"vcIdentifier";
    MARWeatherVC *weatherVC = [magicView dequeueReusablePageWithIdentifier:vcIdentifier];
    if (!weatherVC) {
        weatherVC = (MARWeatherVC *)[UIViewController vcWithStoryboardName:kSBNAME_Weather storyboardId:kSBID_Weather_WeatherVC];
    }
    weatherVC.pageIndex = pageIndex;
    return weatherVC;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {

}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {

}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
}


@end
