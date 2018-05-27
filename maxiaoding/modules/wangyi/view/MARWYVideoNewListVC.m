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
#import <VTMagic.h>

@interface MARWYVideoNewListVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MARWYVideoPlayViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) MARVideoFullVC *fullVC;
@property (nonatomic, strong) MARWYVideoPlayView *playView;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

@end

@implementation MARWYVideoNewListVC
{
    BOOL isFullScreen;
    BOOL ignoreAutoPlayNextVideo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MARWYVideoNewTableCell" bundle:nil] forCellReuseIdentifier:@"MARWYVideoNewTableCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    ignoreAutoPlayNextVideo = NO;
    
    // 开始接受远程控制
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.model.contentOffset = self.tableView.contentOffset;
    ignoreAutoPlayNextVideo = YES;
    
    // 结束远程控制
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
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
    [self hiddenEmptyView];
    [MARDataAnalysis setEventPage:@"WYVideoNewListVC" EventLabel:@"loaddata_WYVideoList"];
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
        @strongify(self)
        if (!strong_self) return;
        strong_self.isLoading = NO;
        NSLog(@">>>>> get new list error : %@", error);
        [strong_self.tableView.mj_header endRefreshing];
        [strong_self.tableView.mj_footer endRefreshing];
        [strong_self showEmptyViewWithImageimage:[UIImage imageNamed:@"img_loaddata_failure"] description:@"网络不稳定，请点击重试" tapBlock:^{
            if (!strong_self) return;
            [strong_self loadData];
            [strong_self hiddenEmptyView];
        }];
    }];
}

- (void)refreshLoadData
{
    [self closePlayer];
    self.model.refreshLoadFn ++;
    [self.model.wyNewArray removeAllObjects];
    self.tableView.contentOffset = CGPointZero;
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

- (MARVideoFullVC *)fullVC
{
    if (_fullVC == nil) {
        self.fullVC = [[MARVideoFullVC alloc] init];
    }
    
    return _fullVC;
}


/**
 定位到在播放的视频cell
 */
- (void)locationMediaCell
{
    if (self.currentSelectedIndexPath) {
        [self.tableView scrollToRowAtIndexPath:self.currentSelectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
            if (cell.playView != self.playView) {
                [cell.playView removeFromSuperview];
            }
            [cell addPlayerView:self.playView];
            cell.playView.hidden = NO;
        }
        else
        {
            if (cell.playView.superview == cell) {
                cell.playView.hidden = YES;
            }
        }
        [cell.playBtn mar_removeAllActionBlocks];
        @weakify(self)
        [cell.playBtn mar_addActionBlock:^(id sender) {
            [MARDataAnalysis setEventPage:@"WYVideoNewListVC" EventLabel:@"click_playWYVideo"];
            [weak_self playVideoWithIndexPath:indexPath isToCenter:YES];
        } forState:UIControlEventTouchUpInside];
        
        [cell.collecionBtn mar_removeAllActionBlocks];
        [cell.collecionBtn mar_addActionBlock:^(id sender) {
            [weak_self clickCollecionBtnAtIndexPath:indexPath];
        } forState:UIControlEventTouchUpInside];
        [cell setCellData:model];
    }
    return cell;
}

- (void)playNextVideo
{
    if (!self.isLoading && self.model.wyNewArray.count > 0 && !isFullScreen && !ignoreAutoPlayNextVideo) {
        if (!self.currentSelectedIndexPath) {
            NSIndexPath *willPlayIndexPath = [NSIndexPath indexPathForRow: 0 inSection:0];
            [self playVideoWithIndexPath:willPlayIndexPath isToCenter:NO];
        }
        else
        {
            if (self.model.wyNewArray.count > self.currentSelectedIndexPath.row + 1)
            {
                NSIndexPath *willPlayIndexPath = [NSIndexPath indexPathForRow:self.currentSelectedIndexPath.row + 1 inSection:self.currentSelectedIndexPath.section];
                [self playVideoWithIndexPath:willPlayIndexPath isToCenter:YES];
            }
        }
    }
    
}

- (void)clickCollecionBtnAtIndexPath:(NSIndexPath *)indexPath
{
    [MARDataAnalysis setEventPage:@"WYVideoNewListVC" EventLabel:@"wangyivideonew_clickcollecion"];
    NSInteger row = indexPath.row;
    if (self.model.wyNewArray.count > row) {
        MARWYVideoNewModel *model = self.model.wyNewArray[row];
        NSArray *searchArray = [MARWYVideoNewModel searchWithWhere:@{@"vid":model.vid}];
        if (searchArray.count > 0) {
            ShowInfoMessage(@"已经收藏到本地，无需再收藏", 1.f);
        }
        else
        {
            BOOL saveFlag = [model updateToDB];
            if (saveFlag) {
                ShowInfoMessage(@"本地收藏成功", 1.f);
            }
            else
            {
                ShowErrorMessage(@"本地收藏成功", 1.f);
            }
        }
        [MARWYNewNetworkManager addVideoCollecion:model success:^(NSURLSessionTask *task, id responseObject) {
            MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
            if (response.isSuccess) {
                ShowSuccessMessage(@"收藏成功", 1.f);
            }
            else
            {
                ShowErrorMessage(@"收藏失败", 1.f);
            }
        } failure:^(NSURLSessionTask *task, NSError *error) {
            ShowErrorMessage(@"收藏失败!", 1.f);
        }];
    }
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
    [MARDataAnalysis setEventPage:@"WYVideoNewListVC" EventLabel:@"wangyivideonew_playvideo"];
    if (self.model.wyNewArray.count > indexPath.row) {
        MARWYVideoNewModel *model = self.model.wyNewArray[indexPath.row];
        
        [self resetPlayView];
        self.playView = [MARWYVideoPlayView videoPlayView];
        _playView.delegate = self;
        
        _playView.title = model.title;
        self.currentSelectedIndexPath = indexPath;
        NSString *urlString = [KTVHTTPCache proxyURLStringWithOriginalURLString:model.mp4_url];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString?:@""]];
        self.playView.playerItem = item;
        
        if (!isFullScreen) {
            if (flag) {
                if (![[self.tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                else
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
            [self mar_gcdPerformAfterDelay:0.5 usingBlock:^(id  _Nonnull objSelf) {
                [self.tableView reloadData];
            }];
        }
        
    }
}

#pragma mark - UIScollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView == scrollView) {
//        if (![[self.tableView indexPathsForVisibleRows] containsObject:self.currentSelectedIndexPath])
//        {
//            [self closePlayer];
//        }
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

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    // 视频播放过程中不可右滑退出
    if (type == kMARNotificationType_MARWYVideoStatusChanged) {
        if (self.magicController.currentViewController == self) {
            // 视频结束，自动播放下一个
            if ([data integerValue] == MARVideoStatusFinish && !isFullScreen && !ignoreAutoPlayNextVideo) {
                if (self.model.wyNewArray.count > self.currentSelectedIndexPath.row + 1)
                {
                    NSIndexPath *willPlayIndexPath = [NSIndexPath indexPathForRow:self.currentSelectedIndexPath.row + 1 inSection:self.currentSelectedIndexPath.section];
                    [self playVideoWithIndexPath:willPlayIndexPath isToCenter:YES];
                }
            }
        }
    }
    else if (type == kMARNotificationType_CloseWYVideoPlay)
    {
        [self closePlayer];
    }
    
}

- (void)clickAppStatusBar
{
    if (self.magicController.currentViewController == self) {
        [self.tableView mar_scrollToTopAnimated:YES];
    }
}

// 重写父类成为响应者方法
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
//                [self.playView pause];
//                [self actionStopButton:self.musicViewNew.stopButton]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
//                [self actionUpButton:self.musicViewNew.upMusicButton];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
                [self playNextVideo];
                MARLog(@">>>>>> play next video\n\n\n\n");
//                [self actionDownButton:self.musicViewNew.downMusicButton];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
                [self.playView play];
//                [self actionStopButton:self.musicViewNew.stopButton];
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [self.playView pause];
//                [self actionStopButton:self.musicViewNew.stopButton];
                break;
                
            default:
                break;
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
