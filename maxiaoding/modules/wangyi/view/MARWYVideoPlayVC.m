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
@interface MARWYVideoPlayVC ()

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playeBtn;

@end

@implementation MARWYVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
}

- (void)UIGlobal
{
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playeBtn];
    
     [self.controlView showTitle:self.videoDetailModel.title coverURLString:self.videoDetailModel.topicImg fullScreenMode:ZFFullScreenModeLandscape];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(@(64));
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(@(kScreenWIDTH * 3 / 4));
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
    _controlView = nil;
    _player = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return self.player.isStatusBarHidden;
}

#pragma mark - Getter And Setter and Lazyload
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor orangeColor];
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

#pragma mark Button actions
- (void)clickPlayBtnAction:(id)sender
{
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
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
    playerManager.assetURL = [NSURL URLWithString:self.videoDetailModel.mp4_url ?: @""];
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
