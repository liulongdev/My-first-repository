//
//  UIImage+MAROpencv.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/15.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <CoreMedia/CMSampleBuffer.h>
@interface UIImage (MAROpencv)

+(UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
-(id)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) cv::Mat CVMat;
@property(nonatomic, readonly) cv::Mat CVGrayscaleMat;

+(cv::Mat)matWithBuffer:(CMSampleBufferRef) sampleBuffer;

@end
