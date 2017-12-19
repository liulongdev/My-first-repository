//
//  MARTXNewsVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARTXNewsVC.h"
#import "MARWXArticleTabelCell.h"
#import <MJRefresh.h>
#import "MARWebViewController.h"
@interface MARTXNewsVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *txNewArray;
@property (nonatomic, strong) MARLoadPageModel *pageModel;
@end

@implementation MARTXNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)UIGlobal
{
    
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 230;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![weak_self.tableView.mj_footer isRefreshing]) {
            weak_self.pageModel.pageIndex = 0;
            [weak_self.txNewArray removeAllObjects];
            [weak_self showActivityView:NO];
            [weak_self loadData];
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
    [self showActivityView:YES];
    NSString *url = [MARTIANXINGUTIL urlWithNewsType:self.type] ?: @"http://api.tianapi.com/vr/";
    
    NSDictionary *paramDic = @{@"num": @(self.pageModel.pageSize), @"page":@(self.pageModel.pageIndex + 1),@"key":TianXingAppKey};
    @weakify(self)
    [MARNetworkManager mar_get:url parameters:paramDic success:^(NSURLSessionTask *task, id responseObject) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        strong_self.pageModel.pageIndex++;
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *newArray = [NSArray mar_modelArrayWithClass:[MARTXNewModel class] json:responseObject[@"newslist"]];
            [strong_self.txNewArray addObjectsFromArray:newArray];
        }
        else
        {
            ShowErrorMessage(responseObject[@"msg"] ?: @"sorry, can't get data!", 1.f);
        }
        [strong_self.tableView.mj_header endRefreshing];
        [strong_self.tableView.mj_footer endRefreshing];
        [strong_self.tableView reloadData];
        if (strong_self.txNewArray.count > 0) {
            [strong_self hiddenEmptyView];
        }
        else
        {
            [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [weak_self showActivityView:NO];
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
        [weak_self.tableView reloadData];
        if (weak_self.txNewArray.count <= 0) {
            [weak_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
    }];
}

- (NSMutableArray *)txNewArray{
    if (!_txNewArray) {
        _txNewArray = [NSMutableArray array];
    }
    return _txNewArray;
}

- (MARLoadPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[MARLoadPageModel alloc] init];
        _pageModel.pageSize = 50;
    }
    return _pageModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.txNewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARWXArticleTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWXArticleTabelCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.txNewArray.count > row) {
        [cell setCellData:self.txNewArray[row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.txNewArray.count > row) {
        MARTXNewModel *txNewModel = self.txNewArray[row];
        if ([txNewModel.url mar_isValidUrl]) {
            MARWebViewController *webVC = [[MARWebViewController alloc] initWithURL:[NSURL URLWithString:txNewModel.url]];
            [self mar_pushViewController:webVC animated:YES];
            
        }
    }
    
}

@end
