//
//  MARWYVideoNewListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoNewListVC.h"
#import "MARWYNewNetworkManager.h"
#import <MJRefresh/MJRefresh.h>
#import "MARWYVideoNewTableCell.h"
#import <KTVHTTPCache.h>
#import "MARVideoFullVC.h"
#import <Masonry.h>
@interface MARWYVideoNewListVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MARWYVideoPlayViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) MARVideoFullVC *fullVC;
@property (nonatomic, strong) MARWYVideoPlayView *playView;
//@property (nonatomic, strong) MARWYVideoNewTableCell *currentSelectedCell;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;
@end

@implementation MARWYVideoNewListVC
{
    BOOL isFullScreen;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self hiddenSystemVolume:YES];
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
    self.tableView.estimatedRowHeight = 230;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.model.wyNewArray.count > 0) {
        [self.tableView reloadData];
    }
    MARLog(@">>>> viewWillAppear");
    [self hiddenEmptyView];
    if (self.model.isDataEmpty) {
        [self showEmptyViewWithImageimage:nil description:@"敬请期待..."];
    }
    if (self.model.wyNewArray.count == 0) {
        [self loadData];
    }
    else if ([[NSDate new] timeIntervalSince1970] - self.model.lastLoadTimeStamp > 60 * 30)
    {
        // 上次加载到页面出现大于半小时自动重新刷新
        [self refreshLoadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self closePlayer];
}

- (void)closePlayer
{
    if (!isFullScreen) {
        [self.playView resetPlayView];
        self.playView = nil;
        self.currentSelectedIndexPath = nil;
    }
}

- (void)loadData
{
    if (self.isLoading) return;
    self.isLoading = YES;
    self.model.lastLoadTimeStamp = [[NSDate new] timeIntervalSince1970];
    MARWYGetVideoNewListR *requestModel = [MARWYGetVideoNewListR new];
    requestModel.offset = self.model.wyNewArray.count;
    requestModel.size = 20;
    requestModel.fn = self.model.refreshLoadFn;
    requestModel.channel = @"T1457068979049";
    requestModel.subtab = self.model.categoryModel.ename;
    @weakify(self)
    [MARWYNewNetworkManager getVideoNewList:requestModel success:^(NSArray<MARWYVideoNewModel *> *array) {
        @strongify(self)
        if (!strong_self) return;
        strong_self.isLoading = NO;
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
        [strong_self.tableView reloadData];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        weak_self.isLoading = NO;
        NSLog(@">>>>> get new list error : %@", error);
        [weak_self.tableView.mj_header endRefreshing];
        [weak_self.tableView.mj_footer endRefreshing];
    }];
}

- (void)refreshLoadData
{
    [self closePlayer];
    self.model.refreshLoadFn ++;
    [self.model.wyNewArray removeAllObjects];
    [self loadData];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.wyNewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARWYVideoNewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWYVideoNewTableCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.model.wyNewArray.count > row) {
        MARWYVideoNewModel *model = self.model.wyNewArray[row];
        if ([self.currentSelectedIndexPath isEqual:indexPath] && !isFullScreen) {
            if (!cell.playView) {
                [cell addPlayerView:self.playView];
            }
            cell.playView.hidden = NO;
        }
        else
        {
            if (cell.playView.superview == cell) {
//                cell.playView = nil;
//                [self resetPlayView];
                cell.playView.hidden = YES;
            }
        }
        [cell.playBtn mar_removeAllActionBlocks];
        @weakify(self)
        [cell.playBtn mar_addActionBlock:^(id sender) {
            [weak_self playVideoWithIndexPath:indexPath isToCenter:YES];
        } forState:UIControlEventTouchUpInside];
        
        [cell setCellData:model];
    }
    return cell;
}

- (void)resetPlayView
{
    if (!isFullScreen) {
        [_playView resetPlayView];
        self.playView = nil;
    }
}

- (void)playVideoWithIndexPath:(NSIndexPath *)indexPath isToCenter:(BOOL)flag
{
    if (self.model.wyNewArray.count > indexPath.row) {
        MARWYVideoNewModel *model = self.model.wyNewArray[indexPath.row];
        
        [self resetPlayView];
        
        if (!self.playView) {
            self.playView = [MARWYVideoPlayView videoPlayView];
            _playView.delegate = self;
            NSLog(@">>>>>>> test");
        }
        _playView.title = model.title;
        self.currentSelectedIndexPath = indexPath;
        NSString *urlString = [KTVHTTPCache proxyURLStringWithOriginalURLString:model.mp4_url];
        urlString = model.mp4_url;
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString?:@""]];
        self.playView.playerItem = item;
        
        if (!isFullScreen) {
            if (flag) {
                if (![[self.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                }
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [self.tableView reloadData];
        }
        
    }
}

#pragma mark - UIScollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView == scrollView) {
        if (![[self.tableView indexPathsForVisibleRows] containsObject:self.currentSelectedIndexPath])
        {
//            [self closePlayer];
        }
    }
}

#pragma mark - MARWYVideoPlayViewDelegate
- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        if ([self.fullVC presentingViewController]) {
            return;
        }
        isFullScreen = YES;
        self.fullVC.playView = self.playView;
//        self.playView = nil;
        self.fullVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:self.fullVC animated:YES completion:nil];
    } else {
        @weakify(self)
        [self.fullVC dismissViewControllerAnimated:YES completion:^{
            @strongify(self)
            strong_self->isFullScreen = NO;
            strong_self.playView = strong_self.fullVC.playView;
            [strong_self.tableView reloadData];
            
        }];
    }
    
    
}

- (MARVideoFullVC *)fullVC
{
    if (_fullVC == nil) {
        self.fullVC = [[MARVideoFullVC alloc] init];
    }
    
    return _fullVC;
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    // 视频播放过程中不可右滑退出
    if (type == kMARNotificationType_MARWYVideoStatusChanged) {
        if ([data integerValue] == MARVideoStatusFinish && !isFullScreen) {
            if (self.model.wyNewArray.count > self.currentSelectedIndexPath.row + 1)
            {
                NSIndexPath *willPlayIndexPath = [NSIndexPath indexPathForRow:self.currentSelectedIndexPath.row + 1 inSection:self.currentSelectedIndexPath.section];
                [self playVideoWithIndexPath:willPlayIndexPath isToCenter:YES];
            }
        }
    }
}

@end

@implementation MARWYVideoNewListPropertyModel

- (instancetype)init
{
    self = [self initWithCategoryModel:nil];
    if (!self) return nil;
    return self;
}

- (instancetype)initWithCategoryModel:(MARWYVideoCategoryTitleModel *)model
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
