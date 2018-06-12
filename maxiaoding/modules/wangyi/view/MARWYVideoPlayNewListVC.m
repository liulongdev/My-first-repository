//
//  MARWYVideoPlayNewListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoPlayNewListVC.h"
#import "ZFPlayer.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"
#import <Masonry.h>

#import "MARWYNewNetworkManager.h"
#import <MJRefresh/MJRefresh.h>
#import <KTVHTTPCache.h>
#import <Masonry.h>
#import <VTMagic.h>
#import "MARWYVideoNewTableCell.h"


@interface MARWYVideoPlayNewListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) ZFAVPlayerManager  *playerManager;

@property (nonatomic, strong) NSMutableArray<NSURL *> *urls;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation MARWYVideoPlayNewListVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc
{
    [_playerManager mar_removeAllBlockObservers];   // 保险起见
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.model.wyNewArray.count > 0) {
        [self.tableView reloadData];
        self.tableView.contentOffset = self.model.contentOffset;
    }
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.model.contentOffset = self.tableView.contentOffset;
    [self closePlayer];
}

- (void)UIGlobal
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.trailing.mas_equalTo(self.view);
    }];
    
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
        [cell.playBtn mar_removeAllActionBlocks];
        @weakify(self)
        [cell.playBtn mar_addActionBlock:^(id sender) {
            [MARDataAnalysis setEventPage:@"WYVideoNewListVC" EventLabel:@"click_playWYVideo"];
            [weak_self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        } forState:UIControlEventTouchUpInside];
        
        [cell.collecionBtn mar_removeAllActionBlocks];
        [cell.collecionBtn mar_addActionBlock:^(id sender) {
            [weak_self clickCollecionBtnAtIndexPath:indexPath];
        } forState:UIControlEventTouchUpInside];
        [cell setCellData:model];
    }
    return cell;
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    @weakify(self)
    NSInteger row = indexPath.row;
    if (self.model.wyNewArray.count > row) {
        MARWYVideoNewModel *model = self.model.wyNewArray[row];
        [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop completionHandler:^{
            @strongify(self)
            if (!strong_self) return;
            [strong_self.controlView showTitle:model.title
                         coverURLString:model.topicImg
                         fullScreenMode:ZFFullScreenModeLandscape];
            [MARGLOBALMANAGER postNotif:kMARNotificationType_MARWYVideoStatusChanged data:@(MARVideoStatusPlaying) object:self];
        }];
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
        [strong_self.model.wyNewArray addObjectsFromArray:array];
        [array enumerateObjectsUsingBlock:^(MARWYVideoNewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSURL *URL = [NSURL URLWithString:obj.mp4_url ?: @""];
            [strong_self.urls addObject:URL];
        }];
        if (strong_self.model.wyNewArray.count <= 0) {
            strong_self.model.isDataEmpty = YES;
            [strong_self showEmptyViewWithImageimage:nil description:@"敬请期待..."];
        }
        else
            strong_self.model.isDataEmpty = NO;
        
        [strong_self.tableView reloadData];
        [strong_self.tableView.mj_header endRefreshing];
        [strong_self.tableView.mj_footer endRefreshing];
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
    [self.urls removeAllObjects];
    self.tableView.contentOffset = CGPointZero;
    [self loadData];
}

#pragma mark custom action
- (void)locationMediaCell
{
    if (_player && _player.currentPlayIndex >= 0 && _player.currentPlayIndex < self.model.wyNewArray.count) {
        NSIndexPath *playingIndexPath = [NSIndexPath indexPathForRow:_player.currentPlayIndex inSection:0];
        [self.tableView scrollToRowAtIndexPath:playingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark Getter | Setter | Lazyload
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        MARAdjustsScrollViewInsets_NO(_tableView, self);
    }
    return _tableView;
}

- (ZFPlayerController *)player
{
    if (!_player) {
        _player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:88];
        _player.controlView = self.controlView;
        _player.shouldAutoPlay = NO;
        _player.assetURLs = self.urls;
        /// 以下设置滑出屏幕后不停止播放
        self.player.stopWhileNotVisible = NO;
        
        @weakify(self)
        _player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            @strongify(self)
            if (!strong_self) return;
            [strong_self.view endEditing:YES];
            [strong_self setNeedsStatusBarAppearanceUpdate];
        };
        
        _player.playerDidToEnd = ^(id  _Nonnull asset) {
            @strongify(self)
            if (!strong_self) return;
            if (!strong_self->_player.isFullScreen) {
                [strong_self closePlayer];
            }
            else
            {
                [strong_self->_player enterFullScreen:NO animated:YES];
                [MARGLOBALMANAGER postNotif:kMARNotificationType_MARWYVideoStatusChanged data:@(MARVideoStatusRemoved) object:nil];
                [strong_self mar_gcdPerformAfterDelay:strong_self->_player.orientationObserver.duration * NSEC_PER_SEC usingBlock:^(id  _Nonnull objSelf) {
                    if (!strong_self) return;
                    [strong_self closePlayer];
                }];
            }
        };
    }
    return _player;
}

- (ZFAVPlayerManager *)playerManager
{
    if (!_playerManager) {
        _playerManager = [[ZFAVPlayerManager alloc] init];
        [_playerManager mar_addObserverForKeyPath:@"playState" options:NSKeyValueObservingOptionNew task:^(id  _Nonnull obj, NSDictionary * _Nonnull change) {
            [MARGLOBALMANAGER postNotif:kMARNotificationType_MARWYVideoStatusChanged data:@([change[NSKeyValueChangeNewKey] integerValue]) object:self];
        }];
    }
    return _playerManager;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}

- (NSMutableArray<NSURL *> *)urls
{
    if (!_urls) {
        _urls = [NSMutableArray arrayWithCapacity:1 << 4];
    }
    return _urls;
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

- (void)setModel:(MARWYVideoPlayNewListPropertyModel *)model
{
    _model = model;
    [self.urls removeAllObjects];
    [self.model.wyNewArray enumerateObjectsUsingBlock:^(MARWYVideoNewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *URL = [NSURL URLWithString:obj.mp4_url ?: @""];
        [self.urls addObject:URL];
    }];
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    if (type == kMARNotificationType_CloseWYVideoPlay)
    {
        [self closePlayer];
    }
}

- (void)closePlayer
{
    [_player stopCurrentPlayingCell];
    [_controlView resetControlView];
    [_playerManager mar_removeAllBlockObservers];
    _playerManager = nil;
    _controlView = nil;
    _player = nil;
    [MARGLOBALMANAGER postNotif:kMARNotificationType_MARWYVideoStatusChanged data:@(MARVideoStatusRemoved) object:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

@implementation MARWYVideoPlayNewListPropertyModel

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
