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
        self.marHitCountLabel.text = [NSString stringWithFormat:@"%ld", (long)model.hitCount];
        
        // 对第一次下载下来的图片进行圆弧剪切，并保存。 所以每次去找缓存、硬盘中找是否有，如果有就使用，不用再去做多余的圆弧剪切功能。
        NSURL *imageURL = [NSURL URLWithString:[model getFirstThumbnail] ?: @""];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
        __weak __typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager].imageCache queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image) {
                weakSelf.marImageView.image = image;
            }
            else
            {
                [weakSelf.marImageView setShowActivityIndicatorView:YES];
                [weakSelf.marImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                [weakSelf.marImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    image = [image mar_imageByRoundCornerRadius:(1/10.f * MIN(image.size.height, image.size.width))];
                    weakSelf.marImageView.image = image;
                    [[SDWebImageManager sharedManager].imageCache storeImage:image recalculateFromImage:YES imageData:nil forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:imageURL] toDisk:YES];
                }];
            }
        }];
    }
}

@end
