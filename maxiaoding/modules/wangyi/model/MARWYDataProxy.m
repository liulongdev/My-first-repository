//
//  MARWYDataProxy.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYDataProxy.h"

@implementation MARWYDataProxy

- (MARWYVideoPlayView *)nVideoPlayView
{
    if (!_nVideoPlayView) {
        _nVideoPlayView = [MARWYVideoPlayView videoPlayView];
    }
    return _nVideoPlayView;
}

@end
