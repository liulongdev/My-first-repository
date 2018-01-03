//
//  MARNetworkResponse.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARNetworkResponse.h"

@implementation MARNetworkResponse

+ (NSDictionary<NSString *,id> *)mar_modelCustomPropertyMapper
{
    return @{@"errCode"     :   @"header.errCode",
             @"errMsg"      :   @"header.errMsg"};
}

- (BOOL)isSuccess
{
    return self.errCode == 0;
}

@end


