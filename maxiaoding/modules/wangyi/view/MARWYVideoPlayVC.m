//
//  MARWYVideoPlayVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoPlayVC.h"
#import "ZFPlayer.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"
#import <Masonry.h>
#import "UIImageView+SDWEBEXT.h"
@interface MARWYVideoPlayVC ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFAVPlayerManager *playerManager;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playeBtn;

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation MARWYVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.videoDetailModel.title;
}

- (void)dealloc
{
    [_playerManager mar_removeAllBlockObservers];
}

- (void)setVideoDetailModel:(MARWYVideoNewDetailModel *)videoDetailModel
{
    _videoDetailModel = videoDetailModel;
    self.title = _videoDetailModel.title;
    [self.coverImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_videoDetailModel.topicImg ?: @""] placeholderImage:nil];
}

- (void)UIGlobal
{
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.coverImageView];
    [self.containerView addSubview:self.playeBtn];
    
//    UIImageView *coverIamgeView = [UIImageView new];

    [self.controlView showTitle:self.videoDetailModel.title coverURLString:self.videoDetailModel.topicImg fullScreenMode:ZFFullScreenModeLandscape];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(@(64));
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(@(kScreenWIDTH * 9 / 16));
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.containerView);
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self closePlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePlayer
{
    [_player stop];
    [_playerManager mar_removeAllBlockObservers];
    _controlView = nil;
    _playerManager = nil;
    _controlView = nil;
    _player = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return self.player.isStatusBarHidden;
}

#pragma mark - Getter And Setter and Lazyload
- (ZFAVPlayerManager *)playerManager
{
    if (!_playerManager) {
        _playerManager = [[ZFAVPlayerManager alloc] init];
        @weakify(self)
        [_playerManager mar_addObserverForKeyPath:@"playState" options:NSKeyValueObservingOptionNew task:^(id  _Nonnull obj, NSDictionary * _Nonnull change) {
            @strongify(self)
            if (!strong_self) return;
            if ([change[NSKeyValueChangeNewKey] integerValue] == 1) // ZFPlayerPlayStatePlaying
                strong_self.fd_interactivePopDisabled = YES;
            else
                strong_self.fd_interactivePopDisabled = NO;
        }];
    }
    return _playerManager;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}

- (UIButton *)playeBtn
{
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_playeBtn setImage:[UIImage imageNamed:@"icon_btn_videoplay"] forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(clickPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

#pragma mark Button actions
- (void)clickPlayBtnAction:(id)sender
{
    self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    @weakify(self)
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [strong_self.view endEditing:YES];
        [strong_self setNeedsStatusBarAppearanceUpdate];
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (!strong_self) return;
        if (strong_self.player.isFullScreen) {
            [strong_self.player enterFullScreen:NO animated:YES];
            [strong_self mar_gcdPerformAfterDelay:strong_self.player.orientationObserver.duration * NSEC_PER_SEC usingBlock:^(id  _Nonnull objSelf) {
                if (!strong_self) return;
                [strong_self.player stop];
            }];
        }
        else
        {
            [strong_self.player stop];
        }
    };
    
    
    NSLog(@">>>>> url : %@", self.videoDetailModel.mp4_url);
    _playerManager.assetURL = [NSURL URLWithString:self.videoDetailModel.mp4_url ?: @""];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
