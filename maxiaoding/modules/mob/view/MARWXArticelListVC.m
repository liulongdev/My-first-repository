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
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 230;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![weakSelf.tableView.mj_footer isRefreshing]) {
            weakSelf.pageModel.pageIndex = 0;
            [weakSelf.articleArray removeAllObjects];
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
    __weak __typeof(self) weakSelf = self;
    [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleListRequestByCID:self.cid page:(self.pageModel.pageIndex+1) size:self.pageModel.pageSize] onResult:^(MOBAResponse *response) {
        if (!response.error) {
            NSArray<MARWXArticleModel *> *articles = [NSArray mar_modelArrayWithClass:[MARWXArticleModel class] json:response.responder[@"result"][@"list"]];
            [weakSelf.articleArray addObjectsFromArray:articles];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARWXArticleModel *model in articles) {
                    [model updateToDB];
                }
            });
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
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
    }
}

@end
