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
#import "MARCookDetailVC.h"
@interface MARSearchCookVC () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *selectCategoryLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableViewBottom;

@property (nonatomic, strong) NSMutableArray<MARCookDetailModel *> *cookDetailArray;
@property (nonatomic, strong) MARLoadPageModel *pageModel;
@property (nonatomic, strong) NSString *searchParamName;

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
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![weakSelf.tableView.mj_footer isRefreshing]) {
            weakSelf.pageModel.pageIndex = 0;
            [weakSelf.cookDetailArray removeAllObjects];
            [weakSelf showActivityView:NO];
            [weakSelf loadData];
        }
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)loadData
{
    static BOOL isLoadingData = NO;
    if (isLoadingData) {
        return;
    }
//    isLoadingData = YES;
    
    __weak __typeof(self) weakSelf = self;
    [self showActivityView:YES];
    if (needReloadData) {
        self.pageModel.pageIndex = 0;
        [self.cookDetailArray removeAllObjects];
        self.selectCategoryLabel.text = self.cookCategoryModel.name ?: @"全部分类";
        [self.tableView reloadData];
        needReloadData = NO;
    }
    [MARMobUtil loadCookListWithCid:self.cookCategoryModel.ctgId cookName:self.searchParamName loadPage:self.pageModel callback:^(MOBAResponse *response, NSArray<MARCookDetailModel *> *cookArray, NSInteger totalCount, NSString *errMsg) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showActivityView:NO];
        if (!response.error) {
            [strongSelf.cookDetailArray addObjectsFromArray:cookArray];
            [strongSelf.tableView reloadData];
            strongSelf.pageModel.pageIndex ++;
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
        }
        [strongSelf.tableView.mj_footer endRefreshing];
        [strongSelf.tableView.mj_header endRefreshing];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (_cookDetailArray.count > row) {
        MARCookDetailModel *model = _cookDetailArray[row];
        [self performSegueWithIdentifier:@"goCookDetailVC" sender:model];
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
    MARCookCategoryListVC *cookCategoryListVC = (MARCookCategoryListVC *)[UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_CookCategoryListVC];
    __weak __typeof(self) weakSelf = self;
    cookCategoryListVC.selectedCallback = ^(MARCookCategoryModel *selectCategoryModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (![strongSelf.cookCategoryModel isEqual:selectCategoryModel] && (strongSelf.cookCategoryModel != nil || selectCategoryModel != nil)) {
            strongSelf.cookCategoryModel = selectCategoryModel;
            strongSelf->needReloadData = YES;
        }
    };
    cookCategoryListVC.isSelectStyle = YES;
    cookCategoryListVC.selectCookCategory = [self.cookCategoryModel copy];
    [self.navigationController pushViewController:cookCategoryListVC animated:YES];
}
@end
