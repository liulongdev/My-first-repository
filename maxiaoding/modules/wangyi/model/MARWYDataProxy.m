//
//  MARWYDataProxy.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYDataProxy.h"

@implementation MARWYDataProxy

- (MARWYVideoPlayView *)playView
{
    if (!_playView) {
        _playView = [MARWYVideoPlayView videoPlayView];
    }
    return _playView;
}

@end
