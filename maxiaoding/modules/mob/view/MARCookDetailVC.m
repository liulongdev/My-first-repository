//
//  MARCookDetailVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookDetailVC.h"
#import "UIImageView+SDWEBEXT.h"
#import <UIImageView+WebCache.h>
#import "MARCookStepTableCell.h"

@interface MARCookDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *cookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookIngredientsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cookImageView;
@property (strong, nonatomic) IBOutlet UIImageView *blurImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableHeaderViewWidth;
@property (strong, nonatomic) IBOutlet UIView *cookSimpleInfoBackGoundView;
@property (strong, nonatomic) IBOutlet UIView *cookSimpleInfoContainerView;
@property (strong, nonatomic) IBOutlet UIView *cookImageBackGroundView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_cookImageBackGroundViewWidth;

@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableFooterViewWidth;

@property (strong, nonatomic) IBOutlet UILabel *cookSumaryLabel;

@end

@implementation MARCookDetailVC
{
    BOOL loadImageSuccess;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;
    self.title = self.cookDetail.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;  // 防止返回崩溃
}

- (void)UIGlobal
{
//    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.constraint_tableHeaderViewWidth.constant = self.constraint_tableFooterViewWidth.constant = kScreenWIDTH;
    
    self.view.backgroundColor = self.tableView.backgroundColor = RGBHEX(0xf4f4f4);
    
    self.cookSimpleInfoBackGoundView.layer.shadowColor=[UIColor grayColor].CGColor;
    self.cookSimpleInfoBackGoundView.layer.shadowOffset=CGSizeMake(5,5);
    self.cookSimpleInfoBackGoundView.layer.shadowOpacity = 0.3;
    self.cookSimpleInfoBackGoundView.layer.shadowRadius=5;
    self.cookSimpleInfoContainerView.layer.masksToBounds = YES;
    self.cookSimpleInfoContainerView.layer.cornerRadius = 10.f;
    
    self.cookImageBackGroundView.layer.masksToBounds = YES;
    self.cookImageBackGroundView.layer.cornerRadius = 10.f;
    
    NSURL *cookImageURL = [NSURL URLWithString:[self cookImageUrlStr] ?: @""];
    @weakify(self)
    [self.blurImageView sd_setImageWithURL:cookImageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self)
        if (!strong_self) return;
        if (error) {
            
        }
        else if (image)
        {
            strong_self->loadImageSuccess = YES;
            strong_self.blurImageView.image = [image mar_imageByBlurRadius:40 tintColor:RGBAHEX(0x29AAFE, 0.3) tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
        }
    }];
    
    [self.cookImageView mar_setImageDefaultCornerRadiusWithURL:cookImageURL];
    self.cookNameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.cookDetail.name ?: @"" attributes:MARSTYLEFORMAT.biaoTiAttrDic];
    NSString *cookInfoStr = @"";
    if (self.cookDetail.ctgTitles && self.cookDetail.ctgTitles.length > 0) {
        cookInfoStr = [cookInfoStr stringByAppendingString:self.cookDetail.ctgTitles];
    }
    self.cookInfoLabel.attributedText = [[NSAttributedString alloc] initWithString:cookInfoStr attributes:MARSTYLEFORMAT.ziBiaoTiAttrDic];
    
    NSString *ingredients = [[self.cookDetail.recipe.ingredients ?: @"" stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
    self.cookIngredientsLabel.attributedText = [[NSAttributedString alloc] initWithString:ingredients attributes:MARSTYLEFORMAT.zhengWenAttrDic];;
    [self _updateTableHeaderView];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.cookSumaryLabel.attributedText = [[NSAttributedString alloc] initWithString:self.cookDetail.recipe.sumary ?: @"" attributes:MARSTYLEFORMAT.zhengWenAttrDic];;
    
    [self _updateTableFooterView];
}

- (void)_updateTableHeaderView
{
    CGFloat height = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableHeaderView.mar_height = height;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableHeaderView.mar_height = height;
    self.tableView.tableHeaderView.mar_width = kScreenWIDTH;
//    [self.tableView reloadData];
}

- (void)_updateTableFooterView
{
    CGFloat height = [self.tableFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableFooterView.mar_height = height;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.tableFooterView.mar_height = height;
    self.tableView.tableFooterView.mar_width = kScreenWIDTH;
    [self.tableView reloadData];
}

- (NSString *)cookImageUrlStr
{
    NSString *urlStr = @"";
    if (self.cookDetail.recipe.img) {
        urlStr = self.cookDetail.recipe.img;
    }
    else
    {
        urlStr = self.cookDetail.thumbnail;
    }
    return urlStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cookDetail.recipe.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cookDetail.recipe.wrapperMethods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARCookStepTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARCookStepTableCell" forIndexPath:indexPath];
    if (self.cookDetail.recipe.wrapperMethods.count > indexPath.row) {
        MARCookStep *stepModel = self.cookDetail.recipe.wrapperMethods[indexPath.row];
        [cell setCellData:stepModel];
        @weakify(self)
        cell.loadAsyncImageCallback = ^{
            [weak_self.tableView reloadData];
        };
    }
    return cell;
}

#pragma mark - UIScollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y + MARCONTENTINSETTOP(self);
    CGFloat maxPicWidth = kScreenWIDTH - 25 * 2;
    
    
    if (loadImageSuccess && offsetY < 0) {
        self.constraint_cookImageBackGroundViewWidth.constant = MAX(150, MIN(maxPicWidth, 150 * (1 - offsetY / 150)));
    }
}

@end
