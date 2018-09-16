//
//  UIImage+MAROpencv.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/15.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "UIImage+MAROpencv.h"
#import "opencv2/highgui/ios.h"
static void ProviderReleaseDataNOP(void *info, const void *data, size_t size)
{
    // Do not release memory
    return;
}

@implementation UIImage (MAROpencv)


-(cv::Mat)CVMat
{
    cv::Mat mat;
    UIImageToMat(self, mat, false);
    return mat;
    
//    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
//    CGFloat cols = self.size.width;
//    CGFloat rows = self.size.height;
//
//    CGFloat tmpWidth = 200;
//    if (cols > 0) {
//        cols = tmpWidth;
//        rows = tmpWidth * rows / rows;
//    }
//
//    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
//
//    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
//                                                    cols,                      // Width of bitmap
//                                                    rows,                     // Height of bitmap
//                                                    8,                          // Bits per component
//                                                    cvMat.step[0],              // Bytes per row
//                                                    colorSpace,                 // Colorspace
//                                                    kCGImageAlphaNoneSkipLast |
//                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
//
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
//    CGContextRelease(contextRef);
//
//    return cvMat;
}
-(cv::Mat)CVGrayscaleMat
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    
    CGFloat tmpWidth = 200;
    if (cols > 0) {
        cols = tmpWidth;
        rows = tmpWidth * rows / rows;
    }
    
    cv::Mat cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNone |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    return [[UIImage alloc] initWithCVMat:cvMat];
}
- (id)initWithCVMat:(const cv::Mat&)cvMat
{
    return MatToUIImage(cvMat);
//    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
//
//    CGColorSpaceRef colorSpace;
//
//    if (cvMat.elemSize() == 1)
//    {
//        colorSpace = CGColorSpaceCreateDeviceGray();
//    }
//    else
//    {
//        colorSpace = CGColorSpaceCreateDeviceRGB();
//    }
//
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
//
//    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
//                                        cvMat.rows,                                     // Height
//                                        8,                                              // Bits per component
//                                        8 * cvMat.elemSize(),                           // Bits per pixel
//                                        cvMat.step[0],                                  // Bytes per row
//                                        colorSpace,                                     // Colorspace
//                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
//                                        provider,                                       // CGDataProviderRef
//                                        NULL,                                           // Decode
//                                        false,                                          // Should interpolate
//                                        kCGRenderingIntentDefault);                     // Intent
//
//    self = [self initWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    CGDataProviderRelease(provider);
//    CGColorSpaceRelease(colorSpace);
//
//    return self;
}

#pragma mark - 将CMSampleBufferRef转为cv::Mat
+(cv::Mat)matWithBuffer:(CMSampleBufferRef) sampleBuffer{
    CVImageBufferRef imgBuf = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    //锁定内存
    CVPixelBufferLockBaseAddress(imgBuf, 0);
    // get the address to the image data
    void *imgBufAddr = CVPixelBufferGetBaseAddress(imgBuf);
    
    // get image properties
    int w = (int)CVPixelBufferGetWidth(imgBuf);
    int h = (int)CVPixelBufferGetHeight(imgBuf);
    
    // create the cv mat
    cv::Mat mat(h, w, CV_8UC4, imgBufAddr, 0);
    
    //转换为灰度图像
    cv::Mat edges;
    cv::cvtColor(mat, edges, CV_BGR2GRAY);
    
    //旋转90度
    cv::Mat transMat;
    cv::transpose(mat, transMat);
    
    //翻转,1是x方向，0是y方向，-1位Both
    cv::Mat flipMat;
    cv::flip(transMat, flipMat, 1);
    
    CVPixelBufferUnlockBaseAddress(imgBuf, 0);
    
    return flipMat;
}

@end

