//
//  UIImageView+SDWEBEXT.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@interface UIImageView (SDWEBEXT)

// 对第一次下载下来的图片进行圆弧剪切，并保存。 所以每次去找缓存、硬盘中找是否有，如果有就使用，不用再去做多余的圆弧剪切功能。

- (void)mar_setImageDefaultCornerRadiusWithURL:(NSURL *)URL;

- (void)mar_setImageDefaultCornerRadiusWithURL:(NSURL *)URL errorImage:(UIImage *)errorImage;

- (void)mar_setImageDefaultCornerRadiusWithURL:(NSURL *)URL errorImage:(UIImage *)image options:(SDWebImageOptions)options;

@end
