//
//  MARWXArticelListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWXArticelListVC.h"
#import <MobAPI/MobAPI.h>
#import "MARWXArticleTabelCell.h"
#import "MARWebViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface MARWXArticelListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MARLoadPageModel *pageModel;
@property (nonatomic, strong) NSMutableArray<MARWXArticleModel *> *articleArray;
@end

@implementation MARWXArticelListVC

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
            [weak_self.articleArray removeAllObjects];
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
    if (self.isAnimating) {
        return;
    }
    [self showActivityView:YES];
    @weakify(self)
    [MARMobUtil loadWXArticleListWithCid:self.cid pageModel:self.pageModel callback:^(MOBAResponse *response, NSArray<MARWXArticleModel *> *articles, NSString *errMsg) {
        [weak_self showActivityView:NO];
        if (!response.error) {
            weak_self.pageModel.pageIndex ++;
            [weak_self.articleArray addObjectsFromArray:articles];
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_footer endRefreshing];
            [weak_self.tableView.mj_header endRefreshing];
            if (weak_self.articleArray.count > 0) {
                [weak_self hiddenEmptyView];
            }
            else
            {
                [weak_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
            }
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
            NSLog(@">>> get ArticleList error : %@", errMsg ?: [response.error localizedDescription]);
            if (weak_self.articleArray.count <= 0) {
                [weak_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
            }
        }
    }];

}

- (MARLoadPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [MARLoadPageModel new];
        _pageModel.pageSize = 20;
    }
    return _pageModel;
}

- (NSMutableArray<MARWXArticleModel *> *)articleArray
{
    if (!_articleArray) {
        _articleArray = [NSMutableArray array];
    }
    return _articleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARWXArticleTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWXArticleTabelCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.articleArray.count > row) {
        [cell setCellData:self.articleArray[row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.articleArray.count > row) {
        MARWXArticleModel *articleModel = self.articleArray[row];
        if ([articleModel.sourceUrl mar_isValidUrl]) {
            MARWebViewController *webVC = [[MARWebViewController alloc] initWithURL:[NSURL URLWithString:articleModel.sourceUrl]];
            [self mar_pushViewController:webVC animated:YES];
            
        }
    }
}

@end
