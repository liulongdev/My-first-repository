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
    
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18.f];
    label.text = @"bottom Test";
    [self.marContentView addSubview:label];
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(100, 15, 15, 100));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
                    if (bottomOffsetY > 44) {
                        self.bottomAppearBlock();
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
