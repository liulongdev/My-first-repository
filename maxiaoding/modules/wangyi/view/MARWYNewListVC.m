//
//  MARWYNewListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/6.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewListVC.h"
#import "MARWYNewTableCell.h"
#import <MJRefresh.h>
#import "MARWYUtility.h"
#import "MARWebViewController.h"

@interface MARWYNewListVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation MARWYNewListVC
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self needReloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.model.contentOffset = self.tableView.contentOffset;
}

- (void)needReloadData
{
    if (self.model.wyNewArray.count > 0) {
        [self.tableView reloadData];
        self.tableView.contentOffset = self.model.contentOffset;
    }
    MARLog(@">>>> viewWillAppear");
    [self hiddenEmptyView];
    if (self.model.isDataEmpty) {
        [self showEmptyViewWithImageimage:nil description:@"敬请期待..."];
    }
    if (self.model.wyNewArray.count == 0) {
        self.tableView.contentOffset = CGPointZero;
        [self loadData];
    }
    else if ([[NSDate new] timeIntervalSince1970] - self.model.lastLoadTimeStamp > 60 * 30)
    {
        // 上次加载到页面出现大于半小时自动重新刷新
        [self refreshLoadData];
    }
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self refreshLoadData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}

- (void)refreshLoadData
{
    self.model.refreshLoadFn ++;
    [self.model.wyNewArray removeAllObjects];
    self.tableView.contentOffset = CGPointZero;
    [self loadData];
}

- (void)loadData
{
    [MARDataAnalysis setEventPage:@"WYNewListVC" EventLabel:@"wangyinew_loaddata"];
    if (self.isLoading) return;
    self.isLoading = YES;
    self.model.lastLoadTimeStamp = [[NSDate new] timeIntervalSince1970];
    MARWYGetNewArticleListR *requestModel = [MARWYGetNewArticleListR new];
    requestModel.offset = self.model.wyNewArray.count;
    requestModel.size = 20;
    requestModel.fn = self.model.refreshLoadFn;
    requestModel.from = requestModel.channel = self.model.categoryModel.tid;
    [requestModel setSignature];
    @weakify(self)
    NSArray *loadRedianArray = @[@"热点"];
    NSArray *loadTitleArray2 = @[@"新闻学院",@"音乐",@"活力冬奥学院",@"云课堂",@"汽车",@"房产",@"商城live",@"二次元",@"佛学",@"阳光法院",@"京东",@"天猫",@"跟贴",@"直播",@"NBA"];
    NSArray *loadTitleArray3 = @[@"萌宠", @"视频", @"美女"];//@[@"萌宠"];
    NSArray *loadTitleArray4 = @[@""];//@[@"段子"];
    if ([@"头条" isEqualToString:self.model.categoryModel.tname]) {
        requestModel.from = @"toutiao";
        requestModel.prog = @"Rpic2";
        @weakify(self)
        [MARWYNewNetworkManager getRecommendNewList:requestModel success:^(NSArray<MARWYNewModel *> *array) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isLoading = NO;
            [strong_self _loadNewArray:array];
            [strong_self.tableView reloadData];
        } failure:^(NSURLSessionTask *task, NSError *error) {
            weak_self.isLoading = NO;
            NSLog(@">>>>> get toutiao list error : %@", error);
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    else if ([loadRedianArray containsObject:self.model.categoryModel.tname]) {
        [MARWYNewNetworkManager getRecommendNewList:requestModel success:^(NSArray<MARWYNewModel *> *array) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isLoading = NO;
            [strong_self _loadNewArray:array];
            [strong_self.tableView reloadData];
        } failure:^(NSURLSessionTask *task, NSError *error) {
            weak_self.isLoading = NO;
            NSLog(@">>>>> get new list error : %@", error);
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    else if ([loadTitleArray2 containsObject:self.model.categoryModel.tname]) {
        [MARWYNewNetworkManager getNewArticleList2:requestModel success:^(NSArray<MARWYNewModel *> *array) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isLoading = NO;
            [strong_self _loadNewArray:array];
            [strong_self.tableView reloadData];
        } failure:^(NSURLSessionTask *task, NSError *error) {
            weak_self.isLoading = NO;
            NSLog(@">>>>> get new list error : %@", error);
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    else if ([loadTitleArray3 containsObject:self.model.categoryModel.tname])
    {
        [MARWYNewNetworkManager getNewArticleList3:requestModel success:^(NSArray<MARWYNewModel *> *array) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isLoading = NO;
            [strong_self _loadNewArray:array];
            [strong_self.tableView reloadData];
        } failure:^(NSURLSessionTask *task, NSError *error) {
            weak_self.isLoading = NO;
            NSLog(@">>>>> get new list error : %@", error);
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    else if ([loadTitleArray4 containsObject:self.model.categoryModel.tname]) {
        [MARWYNewNetworkManager getNewArticleList4:requestModel success:^(NSArray<MARWYNewModel *> *array) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isLoading = NO;
            [strong_self _loadNewArray:array];
            [strong_self.tableView reloadData];
        } failure:^(NSURLSessionTask *task, NSError *error) {
            weak_self.isLoading = NO;
            NSLog(@">>>>> get new list error : %@", error);
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
    else
    {
        [MARWYNewNetworkManager getNewArticleList:requestModel success:^(NSArray<MARWYNewModel *> *array) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isLoading = NO;
            [strong_self _loadNewArray:array];
            [strong_self.tableView reloadData];
        } failure:^(NSURLSessionTask *task, NSError *error) {
            weak_self.isLoading = NO;
            NSLog(@">>>>> get new list error : %@", error);
            [weak_self.tableView reloadData];
            [weak_self.tableView.mj_header endRefreshing];
            [weak_self.tableView.mj_footer endRefreshing];
        }];
    }
}

- (void)_loadNewArray:(NSArray<MARWYNewModel *> *)array
{
    [self.model.wyNewArray addObjectsFromArray:array];
    if (self.model.wyNewArray.count <= 0) {
        self.model.isDataEmpty = YES;
        [self showEmptyViewWithImageimage:nil description:@"敬请期待..."];
    }
    else
        self.model.isDataEmpty = NO;
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MARLog(@">>>>> viewDidAppear");
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    if (_isLoading) {
        if (self.model.wyNewArray.count <= 0) {
            [self showActivityView:YES];
        }
    }
    else
    {
        [self showActivityView:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.wyNewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARWYNewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWYNewTableCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.model.wyNewArray.count > row) {
        MARWYNewModel *model = self.model.wyNewArray[row];
        [cell setCellData:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MARDataAnalysis setEventPage:@"WYNewListVC" EventLabel:@"wangyinew_clickcell"];
    NSInteger row = indexPath.row;
    if (self.model.wyNewArray.count > row) {
        MARWYNewModel *model = self.model.wyNewArray[row];
        if (model.skipType) {
            if ([model.skipType isEqualToString:WYNEWSkipType_PhotoSet]) {
                NSString *skipType = [model.skipID copy];
                if (skipType.length > 4) {
                    skipType = [[skipType substringFromIndex:4] stringByReplacingOccurrencesOfString:@"|" withString:@"/"];
                }
                NSString *urlExtStr = skipType;
                NSString *url = [NSString stringWithFormat:@"%@/%@/%@.json", WANGYIHOST, WYGetPhotoNewDetail, urlExtStr];
                @weakify(self)
                [self showActivityView:YES];
                [MARNetworkManager mar_get:url parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
                    @strongify(self)
                    if (!strong_self) return;
                    [strong_self showActivityView:NO];
//                    NSLog(@"get photos %@", responseObject);
                    if ([responseObject[@"url"] mar_isValidUrl]) {
                        MARWebViewController *webVC = [[MARWebViewController alloc] initWithURL:[NSURL URLWithString:responseObject[@"url"]]];
                        [strong_self mar_pushViewController:webVC animated:YES];
                    }
                } failure:^(NSURLSessionTask *task, NSError *error) {
                    [weak_self showActivityView:NO];
                    NSLog(@">>>>> get photos error : %@", error);
                }];
            }
            else if ([model.skipType isEqualToString:WYNEWSkipType_Video])
            {
                [MARWYNewNetworkManager getVideoNewDetailWithSkipId:model.skipID success:^(NSURLSessionTask *task, id responseObject) {
                    MARWYVideoNewDetailModel *model = [MARWYVideoNewDetailModel mar_modelWithJSON:responseObject];
                    if ([model.vurl mar_isValidUrl]) {
                        MARWebViewController *webVC = [[MARWebViewController alloc] initWithURL:[NSURL URLWithString:model.vurl]];
                        [self mar_pushViewController:webVC animated:YES];
                    }
                    NSLog(@">>>>>>> get videoDetail : %@", responseObject);
                } failure:^(NSURLSessionTask *task, NSError *error) {
                    NSLog(@">>>>>>> get videoDetail error : %@", error);
                }];
            }
            
        }
        else if (![model.docid mar_containsString:@"|"])
        {
            @weakify(self)
            [MARWYNewNetworkManager getNewDetailWithDocId:model.docid success:^(NSURLSessionTask *task, id responseObject) {
                @strongify(self)
                if (!strong_self) return;
//                NSLog(@"get wynew detail : %@", responseObject);
                MARWYNewDetailModel *detailModel = [MARWYNewDetailModel mar_modelWithJSON:responseObject[model.docid]];
                NSLog(@">>>>> %@", detailModel);
                MARWebViewController *webVC = [[MARWebViewController alloc] init];
                webVC.htmlString = [detailModel getHtmlString];
                [strong_self mar_pushViewController:webVC animated:YES];
            } failure:^(NSURLSessionTask *task, NSError *error) {
                NSLog(@"get wynew detail error : %@", error);
            }];
        }
        else if ([model.url mar_isValidUrl]) {
            MARWebViewController *webVC = [[MARWebViewController alloc] initWithURL:[NSURL URLWithString:model.url]];
            [self mar_pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - VTMagicProtocol
- (void)vtm_prepareForReuse
{
    MARLog(@">>>>>  vtm_prepareForReuse");
}

- (void)clickAppStatusBar
{
    if (self.magicController.currentViewController == self) {
        [self.tableView mar_scrollToTopAnimated:YES];
    }
}

@end

@implementation MARNewListPropertyModel

- (instancetype)init
{
    self = [self initWithCategoryModel:nil];
    if (!self) return nil;
    return self;
}

- (instancetype)initWithCategoryModel:(MARWYNewCategoryTitleModel *)model
{
    self = [super init];
    if (!self) return nil;
    _contentOffset = CGPointZero;
    _wyNewArray = [NSMutableArray arrayWithCapacity: 1 << 5];
    _categoryModel = model;
    _refreshLoadFn = 1;
    return self;
    
}

@end
