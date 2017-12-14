//
//  MARMobUtil.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MARMOBUTIL [MARMobUtil sharedInstance]

@interface MARMobUtil : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSDictionary *mobErrorDic;

@end
