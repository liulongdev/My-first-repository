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
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_topViewBottom;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_bottomViewTop;
@end


@implementation MARHomeCustomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = YES;
    self.bottomView.alpha = 0;
    self.topView.alpha = 0;
    self.constraint_topViewBottom.constant = -10;
    self.constraint_bottomViewTop.constant = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static BOOL needAutoScroll = NO;
    if (!needAutoScroll && self.scrollView.isDragging) {
        needAutoScroll = YES;
    }

    if (self.scrollView == scrollView) {
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
                    if (bottomOffsetY > 44 && scrollView.isDecelerating) {
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
                if (offsetY < -44 && scrollView.isDecelerating)
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

@end
