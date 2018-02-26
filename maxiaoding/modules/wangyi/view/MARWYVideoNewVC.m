//
//  MARWYVideoNewVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoNewVC.h"
#import "MARWYNewNetworkManager.h"
#import <VTMagic.h>
#import <Masonry.h>
#import "UIScrollView+MXD.h"
#import "MARWYVideoNewListVC.h"
#import "MARWYVideoPlayView.h"

@interface MARWYVideoNewVC () <VTMagicViewDelegate, VTMagicViewDataSource>
@property (nonatomic, strong) NSArray<MARWYVideoCategoryTitleModel *> *categoryArray;
@property (nonatomic, strong) NSArray *categoryTitleArray;
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSMutableDictionary *wyNewCategoryDictionary;
@property (nonatomic, strong) UIBarButtonItem *locationVideoItem;
@end

@implementation MARWYVideoNewVC
@synthesize categoryArray = _categoryArray;
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
    
    [self _setPopGestureEnabled:YES];
    
    [self categoryArray];
    
}

- (void)_setPopGestureEnabled:(BOOL)enabled
{
    UIScrollView *scrollView = [_magicController.magicView valueForKey:@"contentView"];
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        scrollView.fd_popGestureEnabled = enabled;
        MARAdjustsScrollViewInsets_NO(scrollView, self);
    }
}

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        if (self.isHomeStyle) {
            _magicController.magicView.scrollEnabled = NO;
        }
        _magicController.magicView.itemScale = 1.2;
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
    }
    return _magicController;
}

- (NSMutableDictionary *)wyNewCategoryDictionary
{
    if (!_wyNewCategoryDictionary) {
        _wyNewCategoryDictionary = [NSMutableDictionary dictionaryWithCapacity:1 << 4];
    }
    return _wyNewCategoryDictionary;
}

- (UIBarButtonItem *)locationVideoItem
{
    if (!_locationVideoItem) {
        UIButton *locationVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationVideoBtn setImage:[UIImage imageNamed:@"img_media_play"] forState:UIControlStateNormal];
        locationVideoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        locationVideoBtn.frame = CGRectMake(0, 0, 44, 44);
        [locationVideoBtn addTarget:self action:@selector(locationVideoItemAction:) forControlEvents:UIControlEventTouchUpInside];
        _locationVideoItem = [[UIBarButtonItem alloc] initWithCustomView:locationVideoBtn];
    }
    return _locationVideoItem;
}

- (void)loadData
{
    [MARDataAnalysis setEventPage:@"WYVideoNewVC" EventLabel:@"loaddata_WYVideoTypeList"];
    @weakify(self)
    [MARWYNewNetworkManager getVideoCategoryTitleListSuccess:^(NSArray<MARWYVideoCategoryTitleModel *> *categoryArray) {
        @strongify(self)
        if (!strong_self) return;
        strong_self.categoryArray = categoryArray;
        for (MARWYVideoCategoryTitleModel *model in categoryArray) {
            [model updateToDB];
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"get wangyi new titles error : %@", error);
    }];
}

- (NSArray<MARWYVideoCategoryTitleModel *> *)categoryArray
{
    if (!_categoryArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _categoryArray = (NSArray<MARWYVideoCategoryTitleModel *> *)[MARWYVideoCategoryTitleModel mar_getAllDBModelArray];
            mar_dispatch_async_on_main_queue(^{
                if (_categoryArray.count <= 0) {
                    [self loadData];
                }
                else
                {
                    [self setCategoryTitleDataSource];
                }
            });
        });
        
    }
    return _categoryArray;
}

- (void)setCategoryArray:(NSArray<MARWYVideoCategoryTitleModel *> *)categoryArray
{
    _categoryArray = categoryArray;
    [self setCategoryTitleDataSource];
}

- (void)setCategoryTitleDataSource
{
    if (_categoryArray.count > 0) {
        NSMutableArray *tmpTitles = [NSMutableArray arrayWithCapacity:_categoryArray.count];
        for (MARWYVideoCategoryTitleModel *model in _categoryArray) {
            [tmpTitles addObject:model.cname];
        }
        self.categoryTitleArray = tmpTitles;
        [self.magicController.magicView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VCMagicController Datasource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.categoryTitleArray;
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
    MARWYVideoNewListVC *videoNewListVC = [magicView dequeueReusablePageWithIdentifier:vcIdentifier];
    if (!videoNewListVC) {
        videoNewListVC = (MARWYVideoNewListVC *)[UIViewController vcWithStoryboardName:kSBNAME_Wangyi storyboardId:kSBID_Wangyi_WYVideoNewListVC];
    }
    if (_categoryArray.count > pageIndex) {
        MARWYVideoCategoryTitleModel *key = self.categoryArray[pageIndex];
        if (!self.wyNewCategoryDictionary[key]) {
            self.wyNewCategoryDictionary[key] = [[MARWYVideoNewListPropertyModel alloc] initWithCategoryModel:key];
        }
        videoNewListVC.model  = self.wyNewCategoryDictionary[key];
    }
    return videoNewListVC;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {

}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {

}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    [MARDataAnalysis setEventPage:@"WYVideoNewVC" EventLabel:@"videonew_clickMenuType"];
}

- (void)locationVideoItemAction:(id)sender
{
    MARWYVideoNewListVC *videoNewListVC = self.magicController.currentViewController;
    if ([videoNewListVC isKindOfClass:[MARWYVideoNewListVC class]]) {
        [videoNewListVC locationMediaCell];
    }
    
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    // 视频播放过程中不可右滑退出
    if (type == kMARNotificationType_MARWYVideoStatusChanged) {
        // 首页播放视频时候不可右滑返回
        if (self.magicController.currentPage == 0)
        {
            if ([data integerValue] == MARVideoStatusPlaying) {
                [self _setPopGestureEnabled:NO];
            }
            else
            {
                [self _setPopGestureEnabled:YES];
            }
        }
        // 是否显示右上角定位视频按钮
        if ([data integerValue] == MARVideoStatusPlaying) {
            self.navigationItem.rightBarButtonItem = self.locationVideoItem;
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    else if (type == kMARNotificationType_NetworkChangedEnabel)
    {
        [self categoryArray];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication
          ] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self hiddenSystemVolume:NO];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [[UIApplication sharedApplication
          ] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [self hiddenSystemVolume:YES];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
