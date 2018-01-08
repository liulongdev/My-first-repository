//
//  MARWYNewViewController.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewViewController.h"
#import "MARWYNewNetworkManager.h"
#import "MARWYCategoryTitleCell.h"
#import "MARWYNewTableCell.h"
#import "MARWebViewController.h"
#import "MARWYUtility.h"
#import <VTMagic.h>
#import "MARWYNewListVC.h"
#import <Masonry.h>
#import "UIScrollView+MXD.h"
@interface MARWYNewViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property (nonatomic, strong) NSArray<MARWYNewCategoryTitleModel *> *categoryArray;
@property (nonatomic, strong) NSArray *categoryTitleArray;

@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSMutableDictionary *wyNewCategoryDictionary;
@end

@implementation MARWYNewViewController
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
    UIScrollView *scrollView = [_magicController.magicView valueForKey:@"contentView"];
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        scrollView.fd_popGestureEnabled = YES;
    }
    
//    [_magicController.magicView reloadData];
    [self categoryArray];
}

- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        
        _magicController.magicView.itemScale = 1.2;
//        _magicController.magicView.navigationColor = [UIColor whiteColor];
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

- (void)loadData
{
    @weakify(self)
    [MARWYNewNetworkManager getNewTitleListSuccess:^(NSArray<MARWYNewCategoryTitleModel *> *categoryTitleArray) {
        @strongify(self)
        if (!strong_self) return;
        strong_self.categoryArray = categoryTitleArray;
        
            for (MARWYNewCategoryTitleModel *model in categoryTitleArray) {
                [model updateToDB];
            }
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"get wangyi new titles error : %@", error);
    }];
}

- (NSArray<MARWYNewCategoryTitleModel *> *)categoryArray
{
    if (!_categoryArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _categoryArray = (NSArray<MARWYNewCategoryTitleModel *> *)[MARWYNewCategoryTitleModel mar_getAllDBModelArray];
            if (_categoryArray.count <= 0) {
                [self loadData];
            }
            else
            {
                mar_dispatch_async_on_main_queue(^{
                    [self setCategoryTitleDataSource];
                });
 
            }
        });
        
    }
    return _categoryArray;
}

- (void)setCategoryArray:(NSArray<MARWYNewCategoryTitleModel *> *)categoryArray
{
    _categoryArray = categoryArray;
    [self setCategoryTitleDataSource];
}

- (void)setCategoryTitleDataSource
{
    if (_categoryArray.count > 0) {
        NSMutableArray *tmpTitles = [NSMutableArray arrayWithCapacity:_categoryArray.count];
        for (MARWYNewCategoryTitleModel *model in _categoryArray) {
            [tmpTitles addObject:model.tname];
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
    MARWYNewListVC *wyNewListVC = [magicView dequeueReusablePageWithIdentifier:vcIdentifier];
    if (!wyNewListVC) {
        wyNewListVC = (MARWYNewListVC *)[UIViewController vcWithStoryboardName:kSBNAME_Wangyi storyboardId:kSBID_Wangyi_WYNewListVC];
    }
    if (_categoryArray.count > pageIndex) {
        MARWYNewCategoryTitleModel *key = self.categoryArray[pageIndex];
        if (!self.wyNewCategoryDictionary[key]) {
            self.wyNewCategoryDictionary[key] = [[MARNewListPropertyModel alloc] initWithCategoryModel:key];
        }
        wyNewListVC.model  = self.wyNewCategoryDictionary[key];
    }
    return wyNewListVC;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

@end
