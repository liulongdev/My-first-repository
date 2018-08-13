//
//  MAAIpLocationModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/8/13.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAAIpLocationModel : NSObject

@property (nonatomic, strong) NSString *ip;             // ip地址
@property (nonatomic, strong) NSString *long_ip;        // Long类型的IP地址
@property (nonatomic, strong) NSString *country;        // 国家
@property (nonatomic, strong) NSString *country_id;     // 国家编号
@property (nonatomic, strong) NSString *region;         // 省份
@property (nonatomic, strong) NSString *region_id;      // 省份编号
@property (nonatomic, strong) NSString *city;           // 城市
@property (nonatomic, strong) NSString *city_id;        // 城市编号
@property (nonatomic, strong) NSString *area;           // 地区
@property (nonatomic, strong) NSString *isp;            // 运营商

@end
