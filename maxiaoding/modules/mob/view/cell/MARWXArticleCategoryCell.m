//
//  MARWXArticleCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWXArticleCategoryCell.h"

@interface MARWXArticleCategoryCell()


@end

@implementation MARWXArticleCategoryCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.marTitleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.marTitleLabel.text = data;
    }
}

@end
