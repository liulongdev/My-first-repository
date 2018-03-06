//
//  MARWYVideoCollectVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/3/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoCollectVC.h"
#import "MARWYNewModel.h"
#import "MARWYVideoNewTableCell.h"
#import <KTVHTTPCache.h>
#import "MARVideoFullVC.h"

@interface MARWYVideoCollectVC () <UITableViewDelegate, UITableViewDataSource, MARWYVideoPlayViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *collectVideoArray;

@property (nonatomic, strong) MARVideoFullVC *fullVC;
@property (nonatomic, strong) MARWYVideoPlayView *playView;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

@end

@implementation MARWYVideoCollectVC
{
    BOOL isFullScreen;
    BOOL ignoreAutoPlayNextVideo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏的视频";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCollectVideoData];
}

- (NSMutableArray *)collectVideoArray
{
    if (!_collectVideoArray) {
        _collectVideoArray = [NSMutableArray arrayWithCapacity:1<<5];
    }
    return _collectVideoArray;
}

- (void)loadCollectVideoData
{
    [self hiddenEmptyView];
    [_collectVideoArray removeAllObjects];
    NSArray *localVideoArray = [MARWYVideoNewModel searchWithWhere:nil];
    if (localVideoArray.count <= 0) {
        [self showEmptyViewWithDescription:@"本地无收藏的视频"];
    }
    [self.collectVideoArray addObjectsFromArray:localVideoArray];
    [self.tableView reloadData];
    
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 230;
    [self.tableView registerNib:[UINib nibWithNibName:@"MARWYVideoNewTableCell" bundle:nil] forCellReuseIdentifier:@"MARWYVideoNewTableCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectVideoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARWYVideoNewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWYVideoNewTableCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (_collectVideoArray.count > row) {
        MARWYVideoNewModel *model = _collectVideoArray[row];
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
        
        [cell setCellData:model];
    }
    cell.collecionBtn.hidden = YES;
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_collectVideoArray.count > indexPath.row) {
            MARWYVideoNewModel *model = _collectVideoArray[indexPath.row];
            BOOL deletaFlag = [model deleteToDB];
            if (deletaFlag) {
                [_collectVideoArray removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

#pragma mark - Play Video
- (void)playVideoWithIndexPath:(NSIndexPath *)indexPath isToCenter:(BOOL)flag
{
    [MARDataAnalysis setEventPage:@"WYVideoNewListVC" EventLabel:@"wangyivideonew_playvideo"];
    if (_collectVideoArray.count > indexPath.row) {
        MARWYVideoNewModel *model = _collectVideoArray[indexPath.row];
        
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

- (void)resetPlayView
{
    if (!isFullScreen) {
        [_playView resetPlayView];
        self.playView = nil;
    }
}

- (MARVideoFullVC *)fullVC
{
    if (_fullVC == nil) {
        self.fullVC = [[MARVideoFullVC alloc] init];
    }
    
    return _fullVC;
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

@end
