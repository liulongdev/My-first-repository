//
//  GPUImageBeautifyFilter.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/20.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <GPUImage.h>
@class GPUImageCombinationFilter;
@interface GPUImageBeautifyFilter : GPUImageFilterGroup
{
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}
@end
