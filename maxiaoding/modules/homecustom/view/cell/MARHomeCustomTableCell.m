//
//  MARHomeCustomTableCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeCustomTableCell.h"
#import <Masonry.h>
@interface MARHomeCustomTableCell()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_topViewBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_bottomViewTop;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIColor *oppositeScorllViewColor;
- (void)clickMoreBtnAction:(id)sender;

@end

@implementation MARHomeCustomTableCell
@synthesize oppositeScorllViewColor = _oppositeScorllViewColor;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.topView.backgroundColor = self.bottomView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = YES;
    self.bottomView.alpha = 0;
    self.topView.alpha = 0;
    self.constraint_topViewBottom.constant = -10;
    self.constraint_bottomViewTop.constant = 10;
    
    _triggerBlockTopOffsetY = _triggerBlockBottomOffsetY = 60;
}

- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [UILabel new];
        _topLabel.text = @"别再拉我，胸罩要掉了";
        _topLabel.font = [UIFont systemFontOfSize:14.f];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.numberOfLines = 0;
        _topLabel.textColor = RGBHEX(0x999999);
    }
    return _topLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
        _bottomLabel.text = @"你再拉，我就翻脸了哦";
        _bottomLabel.font = [UIFont systemFontOfSize:14.f];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.textColor = RGBHEX(0x999999);
    }
    return _bottomLabel;
}

- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"More" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(clickMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIColor *)oppositeScorllViewColor
{
    if (!_oppositeScorllViewColor) {
        _oppositeScorllViewColor = RGBHEX(0x999999);
    }
    return _oppositeScorllViewColor;
}

- (void)setOppositeScorllViewColor:(UIColor *)backgroundColor
{
    _oppositeScorllViewColor = backgroundColor;
    self.topLabel.textColor = self.bottomLabel.textColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static BOOL needAutoScroll = NO;
    if (!needAutoScroll && self.scrollView.isTracking) {
        needAutoScroll = YES;
    }
    

    if (self.scrollView == scrollView && needAutoScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat bottomOffsetY = 0;
        
        // 下滑
        if (offsetY > 0)
        {
            self.constraint_topViewBottom.constant = -10;
            if(self.bottomAppearBlock)
            {
                if (scrollView.contentSize.height <= scrollView.mar_height) {
                    bottomOffsetY = offsetY;
                }
                else
                {
                    bottomOffsetY = offsetY - (scrollView.contentSize.height - self.mar_height);
                }
                
                if (bottomOffsetY > 0) {
                    if (bottomOffsetY > self.triggerBlockBottomOffsetY && scrollView.isDecelerating) {
                        if (needAutoScroll) {
                            self.bottomAppearBlock();
                            needAutoScroll = NO;
                            [UIView animateWithDuration:0.25 animations:^{
                                self.bottomView.alpha = 0;
                            }];
                        }
                    }
                    if (scrollView.isTracking) {
                        self.bottomView.alpha = 1;
                    }
                    self.constraint_bottomViewTop.constant = -bottomOffsetY;
                }
                else
                {
                    if (self.bottomView.alpha != 0) {
                        self.bottomView.alpha = 0;
                    }
                }
                    
            }
        }
        else
        {
            self.constraint_bottomViewTop.constant = 10;
            // 上滑
            if (self.topAppearBlock)
            {
                if (offsetY < -self.triggerBlockTopOffsetY && scrollView.isDecelerating)
                {
                    if (needAutoScroll) {
                        self.topAppearBlock();
                        needAutoScroll = NO;
                        [UIView animateWithDuration:0.25 animations:^{
                            self.topView.alpha = 0;
                        }];
                    }
                }
                
                if (scrollView.isTracking) {
                    self.topView.alpha = 1;
                }
                self.constraint_topViewBottom.constant = -bottomOffsetY;
                
            }
        }
    }
}

- (CGFloat)triggerBlockTopOffsetY
{
    return fabs(_triggerBlockTopOffsetY);
}

- (CGFloat)triggerBlockBottomOffsetY
{
    return fabs(_triggerBlockBottomOffsetY);
}

- (void)reset
{
    [self.marContentView mar_removeAllSubviews];
    [self.topView mar_removeAllSubviews];
    [self.bottomView mar_removeAllSubviews];
    self.triggerBlockTopOffsetY = self.triggerBlockBottomOffsetY = 60;
    self.topAppearBlock = nil;
    self.bottomAppearBlock = nil;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.moreBtn];
    [_moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self).mas_offset(-15);
        make.top.mas_equalTo(self).mas_offset(15);
    }];
    
    [self.topView addSubview:self.topLabel];
    [self.bottomView addSubview:self.bottomLabel];
    
    [self.topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self setScrollViewBackgroundColor:nil];
}

- (void)setScrollViewBackgroundColor:(UIColor *)backgroundColor
{
    self.scrollView.backgroundColor = backgroundColor;
    if(backgroundColor){
        UIColor *clr = backgroundColor;
        const CGFloat *componentColors = CGColorGetComponents(clr.CGColor);
        CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
        UIColor *textColor = colorBrightness < 0.8 ? RGBHEX(0xffffff) : RGBHEX(0x999999);
        self.oppositeScorllViewColor = textColor;
    }else{
        self.oppositeScorllViewColor = RGBHEX(0x999999);
    }
}

- (void)clickMoreBtnAction:(id)sender {
    UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_MenuVC];
    [self.mar_viewController mar_pushViewController:vc animated:YES];
}
@end
