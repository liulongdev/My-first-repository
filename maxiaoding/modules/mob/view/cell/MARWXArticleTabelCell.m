//
//  MARWXArticleTabelCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWXArticleTabelCell.h"
#import <UIImageView+WebCache.h>

@interface MARWXArticleTabelCell()
@property (strong, nonatomic) IBOutlet UILabel *marTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *marPubTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *marHitCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *marImageView;

@end

@implementation MARWXArticleTabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.marTitleLabel.preferredMaxLayoutWidth = kScreenWIDTH - 15 * 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MARWXArticleModel class]]) {
        MARWXArticleModel *model = data;
        self.marTitleLabel.text = model.title;
        self.marPubTimeLabel.text = model.pubTime;
        self.marHitCountLabel.text = [NSString stringWithFormat:@"%@", MARSTRWITHINT(model.hitCount)];
        
        NSURL *imageURL = [NSURL URLWithString:[model getFirstThumbnail] ?: @""];
        [self.marImageView mar_setImageDefaultCornerRadiusWithURL:imageURL];
//        [self.marImageView mar_setImageDefaultCornerRadiusWithURLa:imageURL errorImage:nil options:SDWebImageCacheMemoryOnly];
    }
    else if ([data isKindOfClass:[MARTXNewModel class]])
    {
        MARTXNewModel *model = data;
        self.marTitleLabel.text = model.title;
        self.marPubTimeLabel.text = model.ctime;
        self.marHitCountLabel.text = nil;
        
        NSURL *imageURL = [NSURL URLWithString:model.picUrl ?: @""];
        [self.marImageView mar_setImageDefaultCornerRadiusWithURL:imageURL];
//        [self.marImageView mar_setImageDefaultCornerRadiusWithURLa:imageURL errorImage:nil options:SDWebImageCacheMemoryOnly];
    }
}

@end
