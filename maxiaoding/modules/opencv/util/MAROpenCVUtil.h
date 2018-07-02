//
//  MAROpenCVUtil.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/15.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
@interface MAROpenCVUtil : NSObject

+ (void)handelImage:(UIImage *)image;

+ (void)test:(UIImage *)image other:(UIImage *)otherImage;

+ (void)test2:(UIImage *)image other:(UIImage *)otherImage;

+ (void)test3:(UIImage *)image other:(UIImage *)otherImage;

@end
