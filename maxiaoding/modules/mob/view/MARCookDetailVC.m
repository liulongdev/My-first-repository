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
#import "MARMobUtil.h"
#import "MARSocialShareManager.h"

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

@property (nonatomic, strong) UIBarButtonItem *collectionBarBtn;

@property (nonatomic, strong) UIBarButtonItem *shareBarBtn;

@end

@implementation MARCookDetailVC
{
    BOOL loadImageSuccess;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏的菜谱";
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
//    self.fd_prefersNavigationBarHidden = YES;
    [self updateCookDetailUIS];
    if (!_cookDetail) {
        [self loadCookDetailData];
    }
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
    
    [self _updateTableHeaderView];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.cookSumaryLabel.attributedText = [[NSAttributedString alloc] initWithString:self.cookDetail.recipe.sumary ?: @"" attributes:MARSTYLEFORMAT.zhengWenAttrDic];;
    
    [self _updateTableFooterView];
}

- (NSString *)cookId
{
    return _cookId ?: self.cookDetail.menuId;
}

- (void)loadCookDetailData
{
    [self hiddenEmptyView];
    [self showActivityView:YES];
    @weakify(self)
    [MARMobUtil loadCookDetailWithMid:self.cookId callback:^(MOBAResponse *response, MARCookDetailModel *cookDetailModel, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        strong_self.cookDetail = cookDetailModel;
        if (response.error) {
            [strong_self showEmptyViewWithImageimage:[UIImage imageNamed:@"img_loaddata_failure"] description:@"网络不稳定，请点击重试" tapBlock:^{
                if (!strong_self) return;
                [strong_self loadCookDetailData];
                [strong_self hiddenEmptyView];
            }];
        }
    }];
}

- (void)setCookDetail:(MARCookDetailModel *)cookDetail
{
    _cookDetail = cookDetail;
    [self.tableView reloadData];
    if (cookDetail)
    {
        [self updateCollectTitle];
//        self.navigationItem.rightBarButtonItem = self.collectionBarBtn;
        self.navigationItem.rightBarButtonItems = @[self.collectionBarBtn, self.shareBarBtn];
    }
    else
        self.navigationItem.rightBarButtonItem = nil;
}

- (void)updateCookDetailUIS
{
    if (!_cookDetail) nil;
    [self updateCollectTitle];
    self.title = self.cookDetail.name;
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
    self.cookIngredientsLabel.attributedText = [[NSAttributedString alloc] initWithString:ingredients attributes:MARSTYLEFORMAT.zhengWenAttrDic];
    
    [self _updateTableHeaderView];
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

- (UIBarButtonItem *)collectionBarBtn
{
    if (!_collectionBarBtn) {
        _collectionBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(clickCollectionCookAction:)];
    }
    return _collectionBarBtn;
}

- (UIBarButtonItem *)shareBarBtn
{
    if (!_shareBarBtn) {
        _shareBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickShareAction:)];
    }
    return _shareBarBtn;
}

- (void)clickCollectionCookAction:(UIBarButtonItem *)collectionBarBtn
{
    if ([collectionBarBtn.title isEqualToString:@"取消收藏"]) {
        BOOL deletaFlag = [self.cookDetail deleteToDB];
        if (deletaFlag) {
            ShowSuccessMessage(@"取消收藏成功", 1.f);
        }
    }
    else
    {
        self.cookDetail.rowid = 0;
        BOOL saveFlag = [self.cookDetail updateToDB];
        if (saveFlag) {
            ShowSuccessMessage(@"收藏成功", 1.f);
        }
    }
    [self updateCollectTitle];
}

- (void)clickShareAction:(id)sender
{
    MARSocialShareMessageModel *messageModel = [MARSocialShareMessageModel new];
    messageModel.messageType = MARSocialShareMessageType_Image;
    messageModel.title = self.cookDetail.name;
    
    messageModel.image = [UIImage mar_screenShotWithScrollView:self.tableView];
    messageModel.thumImage = [self cookImageUrlStr];
    [MARSocialShareManager setSupportPlatforms];
    [MARSocialShareManager showShareMenuViewInWindowWithMessage:messageModel complete:nil]; 
}

- (void)updateCollectTitle
{
//    NSArray *cookArray = [MARCookDetailModel searchWithWhere:@{@"menuId": self.cookId}];
//    NSString *title = cookArray.count > 0 ? @"取消收藏" : @"收藏";
    NSString *title = [self titleForCollect];
    self.collectionBarBtn.title = title;
}

- (NSString *)titleForCollect
{
    NSArray *cookArray = [MARCookDetailModel searchWithWhere:@{@"menuId": self.cookId}];
    NSString *title = cookArray.count > 0 ? @"取消收藏" : @"收藏";
    return title;
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

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    // 生成UIPreviewAction
    NSString *title = [self titleForCollect];
    UIPreviewAction *collectAction = [UIPreviewAction actionWithTitle:title style:UIPreviewActionStyleDefault                 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if ([title isEqualToString:@"取消收藏"]) {
            BOOL deletaFlag = [self.cookDetail deleteToDB];
            if (deletaFlag) {
                ShowSuccessMessage(@"取消收藏成功", 1.f);
            }
        }
        else
        {
            self.cookDetail.rowid = 0;
            BOOL saveFlag = [self.cookDetail updateToDB];
            if (saveFlag) {
                ShowSuccessMessage(@"收藏成功", 1.f);
            }
        }
    }];
    return @[collectAction];
}


//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
//{
//    // 生成UIPreviewAction
//    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"事件 1" style:UIPreviewActionStyleDefault                 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"Action 1 selected");
//    }];
//    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"事件 2" style:UIPreviewActionStyleDestructive   handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"Action 2 selected");
//    }];
//    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"事件 3" style:UIPreviewActionStyleSelected   handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"Action 3 selected");
//    }];
//    UIPreviewAction *tap1 = [UIPreviewAction actionWithTitle:@"按钮 1" style:UIPreviewActionStyleDefault   handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"tap 1 selected");
//    }];
//    UIPreviewAction *tap2 = [UIPreviewAction actionWithTitle:@"按钮 2" style:UIPreviewActionStyleDestructive   handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"tap 2 selected");
//    }];
//    UIPreviewAction *tap3 = [UIPreviewAction actionWithTitle:@"按钮 3" style:UIPreviewActionStyleSelected   handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"tap 3 selected");
//    }];
//
//    NSArray *actions = @[action1, action2, action3];
//    NSArray *taps = @[tap1, tap2, tap3];
//    UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"一组事件"   style:UIPreviewActionStyleDefault actions:actions];
//    UIPreviewActionGroup *group2 = [UIPreviewActionGroup actionGroupWithTitle:@"一组按钮"   style:UIPreviewActionStyleDefault actions:taps];
//    NSArray *group = @[group1,group2];
//
//    //当然你也可以反三个单独的action对象的数组，而不是group，具体效果，可以自己试一下
//
//    return group;
//}

@end
