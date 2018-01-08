//
//  UIImageView+SDWEBEXT.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "UIImageView+SDWEBEXT.h"

@implementation UIImageView (SDWEBEXT)

- (void)mar_setImageDefaultCornerRadiusWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)image
{
    [self mar_setImageDefaultCornerRadiusWithURL:imageURL placeholderImage:nil options:0];
}

- (void)mar_setImageDefaultCornerRadiusWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)image options:(SDWebImageOptions)options
{
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
    __weak __typeof(self) weakSelf = self;
    [[SDWebImageManager sharedManager].imageCache queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            weakSelf.image = image;
        }
        else
        {
            [weakSelf setShowActivityIndicatorView:YES];
            [weakSelf setIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            [weakSelf sd_setImageWithURL:imageURL placeholderImage:image options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    image = [image mar_imageByRoundCornerRadius:(1/10.f * MIN(image.size.height, image.size.width))];
                    weakSelf.image = image;
                    
                    [[SDWebImageManager sharedManager].imageCache storeImage:image recalculateFromImage:YES imageData:nil forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:imageURL] toDisk:YES];
                    weakSelf.alpha = 0;
                    [UIView animateWithDuration:1 animations:^{
                        weakSelf.alpha = 1;
                    }];
                }
                else if (error)
                {
                    weakSelf.image = [[UIImage imageNamed:@"img_loadimg_failure"] mar_imageByResizeToSize:weakSelf.mar_size contentMode:UIViewContentModeScaleAspectFit];
                }
            }];
        }
    }];
}

@end
