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

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_bottomViewTop;
@end


@implementation MARHomeCustomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = YES;
    
    self.bottomView.hidden = YES;
    
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
                        }
                        self.bottomView.hidden = YES;
                    }
                    self.bottomView.hidden = NO;
                    self.constraint_bottomViewTop.constant = -bottomOffsetY;
                }
                else
                {
                    if (!self.bottomView.hidden) {
                        self.bottomView.hidden = YES;
                    }
                }
                    
            }
        }
        else
        {
            // 上滑
            if (self.topAppearBlock)
            {
                if (offsetY < 0)
                {
                    
                }
                else
                {
                    
                }
            }
        }
    }
}

@end
