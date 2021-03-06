//
//  MAAWhtetherModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/31.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAAWeatherMainColor [UIColor whiteColor]

/**
 @link https://market.aliyun.com/products/57126001/cmapi014302.html?spm=5176.2020520132.101.10.LopetC#sku=yuncode830200000
 */
@class MAAWeatherLifeIndexM;
@class MAAWeatherAQIM;
@class MAAWeatherDayInfoM;
@class MAAWeatherHourInfoM;
@interface MAAWeatherModel : MARBaseDBModel <MARModelDelegate>
@property (nonatomic, strong) NSString *cityid;         //!< 城市ID
@property (nonatomic, strong) NSString *citycode;       //!< 城市天气代号
@property (nonatomic, strong) NSString *city;           //!< 城市
@property (nonatomic, strong) NSString *date;           //!< 日期
@property (nonatomic, strong) NSString *week;           //!< 星期
@property (nonatomic, strong) NSString *weather;        //!< 天气
@property (nonatomic, strong) NSString *temp;           //!< 气温
@property (nonatomic, strong) NSString *temphigh;       //!< 最高气温
@property (nonatomic, strong) NSString *templow;        //!< 最低气温
@property (nonatomic, strong) NSString *img;            //!< 图片数字
@property (nonatomic, strong) NSString *humidity;       //!< 湿度
@property (nonatomic, strong) NSString *pressure;       //!< 气压
@property (nonatomic, strong) NSString *windspeed;      //!< 风速
@property (nonatomic, strong) NSString *winddirect;     //!< 风向
@property (nonatomic, strong) NSString *windpower;      //!< 风级
@property (nonatomic, strong) NSString *updatetime;     //!< 更新时间
@property (nonatomic, strong) NSArray<MAAWeatherLifeIndexM *> *myindex;   //!< 生活指数
@property (nonatomic, strong) MAAWeatherAQIM *aqi;                      //!< AQI
@property (nonatomic, strong) NSArray<MAAWeatherDayInfoM *> *daily;                //!< 按天时间
@property (nonatomic, strong) NSArray<MAAWeatherHourInfoM *> *hourly;

@property (nonatomic, strong) NSDate *requestDate;      // 上一次请求的时间

+ (MAAWeatherModel *)weatherModelWithCityId:(NSString *)cityId;

@end

//!< 生活指数
@interface MAAWeatherLifeIndexM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *iname;          //!< 指数名称
@property (nonatomic, strong) NSString *ivalue;         //!< 指数值
@property (nonatomic, strong) NSString *detail;         //!< 指数详情
@end

//!< 空气质量指数
@class MAAWeatherAQIInfoM;
@interface MAAWeatherAQIM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *so2;            //!< 二氧化硫1小时平均
@property (nonatomic, strong) NSString *so224;          //!< 二氧化硫24小时平均
@property (nonatomic, strong) NSString *no2;            //!< 二氧化氮1小时平均
@property (nonatomic, strong) NSString *no224;          //!< 二氧化氮24小时平均
@property (nonatomic, strong) NSString *co;             //!< 一氧化碳1小时平均
@property (nonatomic, strong) NSString *co24;           //!< 一氧化碳24小时平均
@property (nonatomic, strong) NSString *o3;             //!< 臭氧1小时平均
@property (nonatomic, strong) NSString *o38;            //!< 臭氧8小时平均
@property (nonatomic, strong) NSString *o324;           //!< 臭氧24小时平均
@property (nonatomic, strong) NSString *pm10;           //!< PM10 1小时平均
@property (nonatomic, strong) NSString *pm1024;         //!< PM10 24小时平均
@property (nonatomic, strong) NSString *pm2_5;          //!< PM2.5 1小时平均
@property (nonatomic, strong) NSString *pm2_524;        //!< PM2.5 24小时平均
@property (nonatomic, strong) NSString *iso2;           //!< 二氧化硫指数
@property (nonatomic, strong) NSString *ino2;           //!< 二氧化碳指数
@property (nonatomic, strong) NSString *ico;            //!< 一氧化碳指数
@property (nonatomic, strong) NSString *io3;            //!< 臭氧指数
@property (nonatomic, strong) NSString *io38;           //!< 臭氧八小时指数
@property (nonatomic, strong) NSString *ipm10;          //!< PM10指数
@property (nonatomic, strong) NSString *ipm2_5;         //!< PM2.5指数
@property (nonatomic, strong) NSString *aqi;            //!< AQI指数
@property (nonatomic, strong) NSString *primarypollutant;   //!< 首要污染物
@property (nonatomic, strong) NSString *quality;            //!< 空气质量指数类别， 有“优、良、轻度污染、中度污染、重度污染、严重污染
@property (nonatomic, strong) NSString *timepoint;          //!< 发布时间
@property (nonatomic, strong) MAAWeatherAQIInfoM *aqiinfo;  //!< API指数信息
@end

@interface MAAWeatherAQIInfoM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *level;          //!< 等级
@property (nonatomic, strong) NSString *color;          //!< 指数颜色值
@property (nonatomic, strong) NSString *affect;         //!< 对健康的影响
@property (nonatomic, strong) NSString *measure;        //!< 建议采取措施
@end

@class MAAWeatherDayM;
@class MAAWeatherNigthM;
@interface MAAWeatherDayInfoM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *sunrise;            //!< 日出时间
@property (nonatomic, strong) NSString *sunset;             //!< 日落时间
@property (nonatomic, strong) MAAWeatherDayM *day;          //!< 白天
@property (nonatomic, strong) MAAWeatherNigthM *night;      //!< 夜间
@end

@interface MAAWeatherDayM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *weather;            //!< 天气
@property (nonatomic, strong) NSString *temphigh;           //!< 最高气温
@property (nonatomic, strong) NSString *img;                //!< 图片数字
@property (nonatomic, strong) NSString *winddirect;         //!< 风向
@property (nonatomic, strong) NSString *windpower;          //!< 风级
@end

@interface MAAWeatherNigthM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *weather;            //!< 天气
@property (nonatomic, strong) NSString *templow;            //!< 最低气温
@property (nonatomic, strong) NSString *img;                //!< 图片数字
@property (nonatomic, strong) NSString *winddirect;         //!< 风向
@property (nonatomic, strong) NSString *windpower;          //!< 风级
@end

@interface MAAWeatherHourInfoM : NSObject <MARModelDelegate, NSCopying, NSCoding>
@property (nonatomic, strong) NSString *time;               //!< 时间
@property (nonatomic, strong) NSString *weather;            //!< 天气
@property (nonatomic, strong) NSString *temp;               //!< 气温
@property (nonatomic, strong) NSString *img;                //!< 图片数字
@end

@interface MAAWeatherCityModel : MARBaseDBModel
@property (nonatomic, strong) NSString *cityid;             //!< 城市ID
@property (nonatomic, strong) NSString *parentid;           //!< 上一级城市ID
@property (nonatomic, strong) NSString *citycode;           //!< 城市天气代号
@property (nonatomic, strong) NSString *city;               //!< 城市

+ (NSArray<MAAWeatherCityModel *> *)cityArrayWithParentId:(NSString *)parentId;

+ (NSArray<MAAWeatherCityModel *> *)cityArrayWhere:(id)where;

// 模糊搜索
+ (NSArray<MAAWeatherCityModel *> *)cityArrayWithLikeKey:(NSString *)key;

@end

@interface MAAWeatherLocalCityModel : MAAWeatherCityModel

@property (nonatomic, assign) NSInteger orderIndex;               //!< 排序

+ (instancetype)localCityMWithWeatherCityM:(MAAWeatherCityModel *)model;

@end
