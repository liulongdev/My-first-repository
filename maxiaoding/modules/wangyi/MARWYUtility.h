//
//  MARWYUtility.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/5.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARWYDataProxy.h"
static NSString * const WYNEWSkipType_PhotoSet = @"photoset";
static NSString * const WYNEWSkipType_Video = @"video";

#define MARWYUTILITY [MARWYUtility sharedInstance]

@interface MARWYUtility : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) MARWYDataProxy* dataProxy;

@end
