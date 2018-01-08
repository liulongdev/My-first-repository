//
//  MARCookStepTableCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookStepTableCell.h"
#import <UIImageView+WebCache.h>

@interface MARCookStepTableCell()
@property (strong, nonatomic) IBOutlet UIImageView *stepImageView;
@property (strong, nonatomic) IBOutlet UILabel *stepDetailLabel;

@property (nonatomic, strong
           ) NSDictionary *stepDetailAttrDic;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_stepImageMaxHeight;

@end

@implementation MARCookStepTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSDictionary *)stepDetailAttrDic
{
    if (!_stepDetailAttrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _stepDetailAttrDic = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName : RGBHEX(0x999999)};
    }
    return _stepDetailAttrDic;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MARCookStep class]]) {
        MARCookStep *model = data;
        
        NSURL *imageURL = [NSURL URLWithString:model.img ?: @""];
        if (!model.img || model.img.length <= 0) {
            self.constraint_stepImageMaxHeight.constant = 0;
        }
        else
        {
            self.constraint_stepImageMaxHeight.constant = 1000;
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
            @weakify(self)
            [[SDWebImageManager sharedManager].imageCache queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
                if (image) {
                    weak_self.stepImageView.image = image;
                    weak_self.constraint_stepImageMaxHeight.constant = kScreenWIDTH * image.size.height / image.size.width;
                    if (cacheType == SDImageCacheTypeDisk && weak_self.loadAsyncImageCallback) {
                        weak_self.loadAsyncImageCallback();
                    }
                }
                else
                {
                    [weak_self.stepImageView setShowActivityIndicatorView:YES];
                    [weak_self.stepImageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    [weak_self.stepImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        @strongify(self)
                        if (!strong_self) return;
                        if (error) {
                            
                        }
                        else if (image) {
                            image = [image mar_imageByRoundCornerRadius:(1/30.f * MIN(image.size.height, image.size.width))];
                            strong_self.stepImageView.image = image;
                            strong_self.constraint_stepImageMaxHeight.constant = kScreenWIDTH * image.size.height / image.size.width;
                            if (strong_self.loadAsyncImageCallback) {
                                strong_self.loadAsyncImageCallback();
                            }
                            [[SDWebImageManager sharedManager].imageCache storeImage:image recalculateFromImage:YES imageData:nil forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:imageURL] toDisk:YES];
                            strong_self.stepImageView.alpha = 0;
                            [UIView animateWithDuration:3 animations:^{
                                strong_self.stepImageView.alpha = 1;
                            }];
                        }
                    }];
                }
            }];
        }
        self.stepDetailLabel.attributedText = [[NSAttributedString alloc] initWithString:model.step ?: @"" attributes:MARSTYLEFORMAT.shuoMingAttrDic];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
