//
//  MARWYVideoPlayView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoPlayView.h"

@interface MARWYVideoPlayView ()
@property (nonatomic, strong) AVPlayer *player;

// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) NSIndexPath *indexPath;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) BOOL isReadyToPlay;

@end

@implementation MARWYVideoPlayView

+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MARWYVideoPlayView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.toolView.alpha = 0;
    self.titleLabel.alpha = 0;
    self.isShowToolView = NO;
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"icon_video_slider_thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"icon_video_slider_maximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"icon_video_slider_MinimumTrackImage"] forState:UIControlStateNormal];
    
    [self removeProgressTimer];
    
    self.playOrPauseBtn.selected = YES;
    
    [self.progressSlider addTarget:self action:@selector(slider) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(slider) forControlEvents:UIControlEventTouchUpOutside];
    self.tapGesture.cancelsTouchesInView = NO;
    
    @weakify(self)
    [self mar_whenDoubleTapped:^{
        [weak_self playOrPause:weak_self.playOrPauseBtn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (!self.player) {
        self.player = [[AVPlayer alloc] init];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [self.imageView.layer addSublayer:self.playerLayer];
    }
    self.isReadyToPlay = NO;
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player play];
    [self.progressView startAnimating];
    [self updateProgressInfo];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        [self.progressView stopAnimating];
        [self addProgressTimer];
        self.status = MARVideoStatusPlaying;
        self.isReadyToPlay = YES;
    }
}

// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;//隐藏
            self.titleLabel.alpha = 0;
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 1;
            self.titleLabel.alpha = 1;
            self.isShowToolView = YES;
        }
    }];
}

- (void)play
{
    [self.player play];
    [self addProgressTimer];
    self.status = MARVideoStatusPlaying;
}

- (void)pause
{
    [self.progressView stopAnimating];
    [self.player pause];
    [self removeProgressTimer];
    self.status = MARVideoStatusPause;
    self.toolView.alpha = 1;
    self.titleLabel.alpha = 1;
    self.isShowToolView = YES;
}
//
-(void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}
// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self play];
    } else {
        [self pause];
    }
}

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[MARWeakProxy proxyWithTarget:self] selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (_isReadyToPlay && CMTimeGetSeconds(self.player.currentTime) == CMTimeGetSeconds(self.playerItem.duration)) {
        [self removeProgressTimer];
        self.status = MARVideoStatusFinish;
//        [self resetPlayView];
    }
}

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}

// 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        [self.delegate videoplayViewSwitchOrientation:sender.selected];
    }
}

- (IBAction)slider {
    if (!self.isReadyToPlay) return;
    [self removeProgressTimer];
    [self.player pause];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    [self.progressView startAnimating];
    // 设置当前播放时间
    __weak __typeof(self) weakSelf = self;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        if (finished) {
            [weakSelf addProgressTimer];
            [weakSelf.progressView stopAnimating];
            weakSelf.status = MARVideoStatusPlaying;
            [weakSelf.player play];
        }
    }];

}

- (IBAction)startSlider {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    dMin = dMin<0?0:dMin;
    dSec = dSec<0?0:dSec;
    cMin = cMin<0?0:cMin;
    cSec = cSec<0?0:cSec;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

-(void)resetPlayView {
    [self pause];
    
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;
    
    [self removeFromSuperview];
    self.status = MARVideoStatusRemoved;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setStatus:(MARVideoStatus)status
{
    if (_status != status) {
        [self willChangeValueForKey:@"status"];
        _status = status;
        [MARGLOBALMANAGER postNotif:kMARNotificationType_MARWYVideoStatusChanged data:@(_status) object:self];
        [self didChangeValueForKey:@"status"];
    }
}

@end
