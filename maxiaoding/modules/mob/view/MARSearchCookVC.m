//
//  MARSearchCookVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARSearchCookVC.h"
#import "MARCookInfoTableCell.h"
#import <MJRefresh/MJRefresh.h>
#import "MARCookCategoryListVC.h"
#import "MARCookCategoryCollectionVC.h"
#import "MARCookDetailVC.h"
@interface MARSearchCookVC () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIViewControllerPreviewingDelegate>
@property (strong, nonatomic) IBOutlet UILabel *selectCategoryLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableViewBottom;
@property (strong, nonatomic) IBOutlet UILabel *totalCountLabel;

@property (nonatomic, strong) NSMutableArray<MARCookDetailModel *> *cookDetailArray;
@property (nonatomic, strong) MARLoadPageModel *pageModel;
@property (nonatomic, strong) NSString *searchParamName;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) MARCookDetailVC *cookDetailVC;
- (IBAction)clickSelectCategoryAction:(id)sender;

@end

@implementation MARSearchCookVC
{
    BOOL needReloadData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectCategoryLabel.text = self.cookCategoryModel.name ?: @"全部分类";
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (needReloadData) {
        [self loadData];
    }
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    MJRefreshBackStateFooter
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = footer;
    
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![weak_self.tableView.mj_footer isRefreshing]) {
            weak_self.pageModel.pageIndex = 0;
            [weak_self.cookDetailArray removeAllObjects];
            [weak_self showActivityView:NO];
            [weak_self loadData];
        }
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    self.totalCountLabel.alpha = 0;
}

- (void)loadData
{
    static BOOL isLoadingData = NO;
    if (isLoadingData) {
        return;
    }
//    isLoadingData = YES;
    [MARDataAnalysis setEventPage:@"searchCookVC" EventLabel:@"loaddata_cookDetailList"];
    [self showActivityView:YES];
    if (needReloadData) {
        self.pageModel.pageIndex = 0;
        [self.cookDetailArray removeAllObjects];
        self.selectCategoryLabel.text = self.cookCategoryModel.name ?: @"全部分类";
        [self.tableView reloadData];
        needReloadData = NO;
    }
    @weakify(self)
    [MARMobUtil loadCookListWithCid:self.cookCategoryModel.ctgId cookName:self.searchParamName loadPage:self.pageModel callback:^(MOBAResponse *response, NSArray<MARCookDetailModel *> *cookArray, NSInteger totalCount, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        if (!response.error) {
            [strong_self.cookDetailArray addObjectsFromArray:cookArray];
            [strong_self.tableView reloadData];
            strong_self.pageModel.pageIndex ++;
            strong_self.totalCount = totalCount;
            if (strong_self.cookDetailArray.count > 0) {
                [strong_self hiddenEmptyView];
            }
            else
            {
                [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
            }
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
            [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
        [strong_self.tableView.mj_footer endRefreshing];
        [strong_self.tableView.mj_header endRefreshing];
    }];
    
}

- (NSMutableArray<MARCookDetailModel *> *)cookDetailArray
{
    if (!_cookDetailArray) {
        _cookDetailArray = [NSMutableArray array];
    }
    return _cookDetailArray;
}

- (MARLoadPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [MARLoadPageModel new];
        _pageModel.pageIndex = 0;
        _pageModel.pageSize = 20;
    }
    return _pageModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [MARDataAnalysis setEventPage:@"cookDetailListVC" EventLabel:@"cook_click_searchCookList"];
    self.searchParamName = [textField.text mar_stringByTrim];
    [self.view endEditing:YES];
    needReloadData = YES;
    [self loadData];
    return NO;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cookDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARCookInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARCookInfoTableCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (_cookDetailArray.count > row) {
        MARCookDetailModel *model = _cookDetailArray[row];
        [cell setCellData:model];
        if (model.recipe.method.count > 0 || model.recipe.ingredients || model.recipe.sumary) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [self mar_registerForPreviewingWithDelegate:self sourceView:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (_cookDetailArray.count > row) {
        [MARDataAnalysis setEventPage:@"cookDetailListVC" EventLabel:@"cook_clickcell_cookDetail"];
        MARCookDetailModel *model = _cookDetailArray[row];
        if (model.recipe.method.count > 0 || model.recipe.ingredients || model.recipe.sumary) {
            [self performSegueWithIdentifier:@"goCookDetailVC" sender:model];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goCookDetailVC"]) {
        MARCookDetailVC *cookDetailVC = segue.destinationViewController;
        if ([cookDetailVC isKindOfClass:[MARCookDetailVC class]] && [sender isKindOfClass:[MARCookDetailModel class]]) {
            cookDetailVC.cookDetail = sender;
        }
    }
}

- (IBAction)clickSelectCategoryAction:(id)sender {
//    MARCookCategoryListVC *cookCategoryListVC = (MARCookCategoryListVC *)[UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_CookCategoryListVC];
    MARCookCategoryCollectionVC *cookCategoryListVC = (MARCookCategoryCollectionVC *)[UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_CookCategoryCollectionVC];
    @weakify(self)
    cookCategoryListVC.selectedCallback = ^(MARCookCategoryModel *selectCategoryModel) {
        @strongify(self)
        if (!strong_self) return;
        if (![strong_self.cookCategoryModel isEqual:selectCategoryModel] && (strong_self.cookCategoryModel != nil || selectCategoryModel != nil)) {
            strong_self.cookCategoryModel = selectCategoryModel;
            strong_self->needReloadData = YES;
        }
    };
    cookCategoryListVC.isSelectStyle = YES;
    cookCategoryListVC.selectCookCategory = [self.cookCategoryModel copy];
    [self mar_pushViewController:cookCategoryListVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView == scrollView && self.totalCount > 0) {
        if (scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating) {
            self.totalCountLabel.text = MARSTRWITHINT(self.totalCount);
            if (self.totalCountLabel.alpha == 0) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.totalCountLabel.alpha = 1;
                }];
            }
            NSIndexPath *indexPath = self.tableView.indexPathsForVisibleRows.lastObject;
            NSString *countStr = [NSString stringWithFormat:@"%@/%@", MARSTRWITHINT(indexPath.row + 1), MARSTRWITHINT(self.totalCount)];
            if (![self.totalCountLabel.text isEqualToString:countStr]) {
                self.totalCountLabel.text = countStr;
            }
        }
        else
        {
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.tableView == scrollView)
    {
        if (self.totalCountLabel.alpha == 1) {
            [UIView animateWithDuration:0.25 animations:^{
                self.totalCountLabel.alpha = 0;
            }];
        }
    }
}

#pragma mark - ForceTouch Delegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    if ([self.presentedViewController isKindOfClass:[MARCookDetailVC class]]) {
        return nil;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
#pragma clang diagnostic pop
    NSInteger row = indexPath.row;
    if (_cookDetailArray.count > row) {
        MARCookDetailModel *model = _cookDetailArray[row];
        if (model.recipe.method.count > 0 || model.recipe.ingredients || model.recipe.sumary) {
            _cookDetailVC = (MARCookDetailVC *)[UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_CookDetailVC];
            _cookDetailVC.cookDetail = model;
            return _cookDetailVC;
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    if (_cookDetailVC) {
        [self mar_pushViewController:_cookDetailVC animated:YES];
    }
}


@end
