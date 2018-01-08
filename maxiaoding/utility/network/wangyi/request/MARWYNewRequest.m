//
//  MARWYNewRequest.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewRequest.h"
#import <FCUUID.h>
@implementation MARWYNewRequest

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _devId = @"";
    _version = @"31.0";
    _spever = @"false";
    _net = @"wifi";
    _canal = @"maxiaoding";
    _ts = MARSTRWITHINT((long)([[NSDate new] timeIntervalSince1970]));
    _encryption = @"1";
//    _sign = @"7eFT5nh9qzmonv+iOvKmqmk6ziKtcFHuolPv9o5qzst48ErR02zJ6/KXOnxX046I";
    return self;
}

- (void)setSignature
{
    _ts = @"1515393095";
    _sign = @"7eFT5nh9qzmonv+iOvKmqmk6ziKtcFHuolPv9o5qzst48ErR02zJ6/KXOnxX046I";
    _devId = @"I9mEvOjEpr7x6qKZ0E/jqz+XNYccr98jb6FUP/c34MDLszEoKIcbpbZWUwpshTwP";
}

@end

@implementation MARWYSpecialNewRequest

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _devId = @"I9mEvOjEpr7x6qKZ0E/jqz+XNYccr98jb6FUP/c34MDLszEoKIcbpbZWUwpshTwP"; //@"";
    _passport = @"";
    _version = @"31.0";
    _spever = @"false";
    _net = @"wifi";
    _canal = @"appstore";
    _ts = @"1515393095"; //MARSTRWITHINT((long)([[NSDate new] timeIntervalSince1970]));
    _encryption = @"1";
    _sign = @"7eFT5nh9qzmonv+iOvKmqmk6ziKtcFHuolPv9o5qzst48ErR02zJ6/KXOnxX046I";
    return self;
}

@end

@implementation MARWYGetNewListWithCategoryR

@end

@implementation MARWYGetNewArticleListR

@end

@implementation MARWYGetTouTiaoNewListR

@end

@implementation MARWYGetChanListNewsR

@end

@implementation MARWYGetPhotoNewListR

@end

@implementation MARWYGetVideoNewListR

@end
