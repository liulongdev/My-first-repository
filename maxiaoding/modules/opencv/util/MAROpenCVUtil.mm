//
//  MAROpenCVUtil.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/15.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAROpenCVUtil.h"
#include <stdio.h>
#include <iostream>
#import <opencv2/nonfree/features2d.hpp>
#import <opencv2/core/core.hpp>
#import <opencv2/features2d/features2d.hpp>
#import <opencv2/highgui/highgui.hpp>
#import <opencv2/legacy/legacy.hpp>
#import "UIImage+MAROpencv.h"
@implementation MAROpenCVUtil

+ (void)handelImage:(UIImage *)image
{
    cv::Mat mat = [self cvMatFromUIImage:image];
    if (!mat.data) {
        NSLog(@">> error 1 : null");
        return;
    }
    
    //-- Step 1: Detect the keypoints using SURF Detector
    int minHessian = 400;
    cv::Mat descriptors_1;
    
    cv::SurfFeatureDetector *surfDetector;
    std::vector<cv::KeyPoint> keypoints_1, keypoints_2;
}

+ (void)test3:(UIImage *)image other:(UIImage *)otherImage
{
    cv::Mat img_1 = [image CVMat];
    cv::Mat img_2 = [otherImage CVMat];
    
    cv::ORB orb(100);
    std::vector<cv::KeyPoint> keyPoints_1, keyPoints_2;
    cv::Mat descriptors_1, descriptors_2;
    
    orb(img_1, cv::Mat(),keyPoints_1,  descriptors_1);
    orb(img_2, cv::Mat(),keyPoints_2,  descriptors_2);
    
    cv::BruteForceMatcher<cv::HammingLUT> matcher;
    
    std::vector<cv::DMatch> matches;
    
    matcher.match(descriptors_1, descriptors_2, matches);
    
    double max_dist = 0; double min_dist = 100;
    //-- Quick calculation of max and min distances between keypoints
    for( int i = 0; i < descriptors_1.rows; i++ )
    {
        double dist = matches[i].distance;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
    }
    printf("-- Max dist : %f \n", max_dist );
    printf("-- Min dist : %f \n", min_dist );
    
    //-- Draw only "good" matches (i.e. whose distance is less than 0.6*max_dist )
    //-- PS.- radiusMatch can also be used here.
    std::vector<cv::DMatch > good_matches;
    for( int i = 0; i < descriptors_1.rows; i++ )
    {
        if( matches[i].distance <= 0.6*max_dist )
        {
            good_matches.push_back( matches[i]);
        }
    }
    printf("----> size : %lu", good_matches.size());
}

+ (void)test2:(UIImage *)image other:(UIImage *)otherImage
{
    cv::Mat img_object = [image CVMat];
    cv::Mat img_scene = [otherImage CVMat];
    
    if( !img_object.data || !img_scene.data )
    { std::cout<< " --(!) Error reading images " << std::endl; return; }
    
    //-- Step 1: Detect the keypoints using SURF Detector
    int minHessian = 20;
    
    cv::FastFeatureDetector detector( minHessian );
    
    std::vector<cv::KeyPoint> keypoints_object, keypoints_scene;
    
    detector.detect( img_object, keypoints_object );
    detector.detect( img_scene, keypoints_scene );
    
    //-- Step 2: Calculate descriptors (feature vectors)
    cv::SurfDescriptorExtractor extractor;
    
    cv::Mat descriptors_object, descriptors_scene;
    
    extractor.compute( img_object, keypoints_object, descriptors_object );
    extractor.compute( img_scene, keypoints_scene, descriptors_scene );
    
    //-- Step 3: Matching descriptor vectors using FLANN matcher
    cv::BruteForceMatcher<cv::L2<float> > matcher;
    std::vector< cv::DMatch > matches;
    matcher.match( descriptors_object, descriptors_scene, matches );
    
    double max_dist = 0; double min_dist = 100;
    
    //-- Quick calculation of max and min distances between keypoints
    for( int i = 0; i < descriptors_object.rows; i++ )
    { double dist = matches[i].distance;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
    }
    
    printf("-- Max dist : %f \n", max_dist );
    printf("-- Min dist : %f \n", min_dist );
    
    //-- Draw only "good" matches (i.e. whose distance is less than 3*min_dist )
    std::vector< cv::DMatch > good_matches;
    
    for( int i = 0; i < descriptors_object.rows; i++ )
    { if( matches[i].distance <= 3*min_dist )
    { good_matches.push_back( matches[i]); }
    }
    
    cv::Mat img_matches;
    drawMatches( img_object, keypoints_object, img_scene, keypoints_scene,
                good_matches, img_matches, cv::Scalar::all(-1), cv::Scalar::all(-1),
                std::vector<char>(), cv::DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
    //-- Localize the object
    std::vector<cv::Point2f> obj;
    std::vector<cv::Point2f> scene;
    
    printf("-- good matches : %lu \n", good_matches.size());
    
    for( int i = 0; i < good_matches.size(); i++ )
    {
        //-- Get the keypoints from the good matches
        obj.push_back( keypoints_object[ good_matches[i].queryIdx ].pt );
        scene.push_back( keypoints_scene[ good_matches[i].trainIdx ].pt );
    }
    
    if (obj.size()>3) {
        printf("--<<<<<  start");
        cv::Mat H = cv::findHomography( obj, scene, CV_RANSAC );
        
        //-- Get the corners from the image_1 ( the object to be "detected" )
        std::vector<cv::Point2f> obj_corners(4);
        obj_corners[0] = cvPoint(0,0); obj_corners[1] = cvPoint( img_object.cols, 0 );
        obj_corners[2] = cvPoint( img_object.cols, img_object.rows ); obj_corners[3] = cvPoint( 0, img_object.rows );
        std::vector<cv::Point2f> scene_corners(4);
        printf("--<<<<<  start2");
        perspectiveTransform( obj_corners, scene_corners, H);
        printf("--<<<<<  start3");
        //-- Draw lines between the corners (the mapped object in the scene - image_2 )
        line( img_matches, scene_corners[0] + cv::Point2f( img_object.cols, 0), scene_corners[1] + cv::Point2f( img_object.cols, 0), cv::Scalar(0, 255, 0), 4 );
        line( img_matches, scene_corners[1] + cv::Point2f( img_object.cols, 0), scene_corners[2] + cv::Point2f( img_object.cols, 0), cv::Scalar( 0, 255, 0), 4 );
        line( img_matches, scene_corners[2] + cv::Point2f( img_object.cols, 0), scene_corners[3] + cv::Point2f( img_object.cols, 0), cv::Scalar( 0, 255, 0), 4 );
        line( img_matches, scene_corners[3] + cv::Point2f( img_object.cols, 0), scene_corners[0] + cv::Point2f( img_object.cols, 0), cv::Scalar( 0, 255, 0), 4 );
        printf("--<<<<<  start4");
        //-- Show detected matches
//        imshow( "Good Matches & Object detection", img_matches );
        printf("--<<<<<  end");
    }  
}

+ (void)test:(UIImage *)image other:(UIImage *)otherImage;
{
    
    cv::Mat img_1 = [image CVMat];
    cv::Mat img_2 = [otherImage CVMat];
    
    if( !img_1.data || !img_2.data )
    { return; }
    
    //-- Step 1: Detect the keypoints using SURF Detector
    int minHessian = 15;
    
    cv::SurfFeatureDetector detector( minHessian );
    
    std::vector<cv::KeyPoint> keypoints_1, keypoints_2;
    
    detector.detect( img_1, keypoints_1 );
    detector.detect( img_2, keypoints_2 );
    
    //-- Step 2: Calculate descriptors (feature vectors)
    cv::SurfDescriptorExtractor extractor;
    
    cv::Mat descriptors_1, descriptors_2;
    
    extractor.compute( img_1, keypoints_1, descriptors_1 );
    extractor.compute( img_2, keypoints_2, descriptors_2 );
    
    //-- Step 3: Matching descriptor vectors with a brute force matcher
    cv::BFMatcher matcher(cv::NORM_L2, true);
//    cv::BFMatcher< L2<float> > matcher;
    std::vector< cv::DMatch > matches;
    matcher.match( descriptors_1, descriptors_2, matches );
    
    //-- Draw matches
    cv::Mat img_matches;
    cv::drawMatches( img_1, keypoints_1, img_2, keypoints_2, matches, img_matches );
    
    //-- Show detected matches
    cv::imshow("Matches", img_matches );
    
    
}



// UIImage -> CvMat
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    @synchronized (image) {
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
        CGFloat cols = image.size.width;
        CGFloat rows = image.size.height;
        
        cv::Mat cvMat(rows, cols, CV_8UC4);
        
        CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,
                                                        cols,
                                                        rows,
                                                        8,
                                                        cvMat.step[0],
                                                        colorSpace,
                                                        kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
        
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
        CGContextRelease(contextRef);
        return cvMat;
    }
}

// CvMat -> UIImage
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {//可以根据这个决定使用哪种
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

// UIImage -> IplImage
+ (IplImage *)IplImageFromUIImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
    CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    return iplimage;
}

// IplImage -> UIImage
+ (UIImage *)UIImageFromIplImage:(IplImage *)image
{
    NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image->width, image->height, image->depth, image->nChannels, image->widthStep, image->channelSeq);
    UIImage *result = nil;
    
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    if (provider) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace) {
            CGImageRef imageRef = CGImageCreate(image->width, image->height,
                                                image->depth, image->depth * image->nChannels, image->widthStep,
                                                colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                                provider, NULL, NO, kCGRenderingIntentDefault);
            
            if (imageRef) {
                result = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
            }
            
            CGColorSpaceRelease(colorSpace);
        }
        
        CGDataProviderRelease(provider);
    }
    
    return result;
}

@end
