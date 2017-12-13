//
//  MARWXArticleModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWXArticleModel.h"

@implementation MARWXArticleModel

- (NSString *)getFirstThumbnail
{
    NSArray<NSString *> *thumbnails = [self getThumbnailArray];
    if (thumbnails.count > 0) {
        return thumbnails[0];
    }
    return nil;
}
- (NSArray<NSString *> *)getThumbnailArray
{
    return [self.thumbnails componentsSeparatedByString:@"$"];
}

@end
