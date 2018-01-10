//
//  MARBaseViewController.m
//  
//
//  Created by Martin.Liu on 15/12/21.
//  Copyright © 2015年 MAR. All rights reserved.
//

#import "MARBaseViewController.h"
#import <objc/runtime.h>
#import <Masonry.h>
#import "MAREmptyView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MARBaseViewController ()
@property (nonatomic, strong) UITapGestureRecognizer* resignFirstResponserGesture;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) MAREmptyView *tipEmptyView;
@end

@implementation MARBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
//        self.navigationController.navigationBar.translucent = NO;
        // 需要底栈VC的手势禁掉
        if (self.navigationController.viewControllers[0] == self) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    self.view.backgroundColor = RGBHEX(MARColor_VCBackgound);
    [self addObserverGlobal];
    if ([self respondsToSelector:@selector(UIGlobal)]) {
        [self UIGlobal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - set YES/NO to indicate wheather resign first responder when tap view
#pragma mark start
- (void)setTapResignTFS:(BOOL)isTapResignTFS
{
    if (isTapResignTFS) {
        [self.view addGestureRecognizer:self.resignFirstResponserGesture];
    }
    else
    {
        [self.view removeGestureRecognizer:_resignFirstResponserGesture];
    }
}

- (UITapGestureRecognizer *)resignFirstResponserGesture
{
    if (!_resignFirstResponserGesture) {
        _resignFirstResponserGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTFS)];
        _resignFirstResponserGesture.cancelsTouchesInView = NO;
    }
    return _resignFirstResponserGesture;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicatorView;
}

- (void)resignTFS
{
    [self.view endEditing:YES];
}
#pragma mark end
#pragma mark -

- (void)UIGlobal{}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

//statusbar 用白色字体
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#pragma mark -
#pragma mark 全局通知  -- start
- (void)addObserverGlobal{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__getNotif:) name:kMARGlobalNotification object:nil];
}

- (void)__getNotif:(NSNotification *)sender{
    
    NSDictionary *dd=sender.userInfo;
    NSInteger ty=-1;
    id data;
    id obj;
    
    if ([dd objectForKey:@"type"] && [[dd objectForKey:@"type"] isKindOfClass:[NSNumber class]]) {
        ty=[[dd objectForKey:@"type"]integerValue];
    }
    
    data=[dd objectForKey:@"data"];
    obj=[dd objectForKey:@"object"];
    
    [self getNotifType:ty data:data target:obj];
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj{}

- (void)__removeObserverGlobal{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMARGlobalNotification object:nil];
}

#pragma mark 全局通知  -- end
#pragma mark -

- (void)showActivityView:(BOOL)show
{
    if (show) {
        [self.view addSubview:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        [self.activityIndicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.mas_topLayoutGuide).mas_offset(kScreenHeight * 1/4);
        }];
    }
    else
    {
        [_activityIndicatorView stopAnimating];
//        [_activityIndicatorView removeFromSuperview];
//        _activityIndicatorView = nil;
    }
}

- (BOOL)isAnimating
{
    return _activityIndicatorView.isAnimating;
}

- (MAREmptyView *)tipEmptyView
{
    if (!_tipEmptyView) {
        _tipEmptyView = [MAREmptyView new];
    }
    return _tipEmptyView;
}

- (void)hiddenEmptyView
{
    [_tipEmptyView removeFromSuperview];
    [_tipEmptyView removeFromSuperview];
}

- (void)showEmptyViewWithDescription:(NSString *)description
{
    [self.view addSubview:self.tipEmptyView];
    self.tipEmptyView.emptyDescription = description;
    CGFloat width = kScreenWidth * 3 / 5;
    [self.tipEmptyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(@(-40));
        make.width.mas_equalTo(@(width));
        make.height.mas_lessThanOrEqualTo(@(width * 4/3));
    }];
}

- (void)showEmptyViewWithImageimage:(UIImage *)image description:(NSString *)description
{
    [self.view addSubview:self.tipEmptyView];
    self.tipEmptyView.emptyImage = image;
    self.tipEmptyView.emptyDescription = description;
    CGFloat width = kScreenWidth * 3 / 5;
    [self.tipEmptyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(@(-40));
        make.width.mas_equalTo(@(width));
        make.height.mas_lessThanOrEqualTo(@(width * 4/3));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)hiddenSystemVolume:(BOOL)hidden
{
    if (hidden) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 200, 300, 100)];
        volumeView.userInteractionEnabled = NO;
        volumeView.alpha = 0.0001;
        //把自定义的MPVolumeView贴在view上
        [self.view addSubview: volumeView];
    }
    else
    {
        for (UIView *view in [self.view subviews]) {
            if ([view isKindOfClass:[MPVolumeView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)dealloc
{
    [self __removeObserverGlobal];
}

@end
