//
//  MARALIAPINetworkManager.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/29.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAARequestModel.h"
#import "MAAWeatherModel.h"
#import "MAACarModel.h"
#import "MAANewModel.h"
#import "MAAIpLocationModel.h"

/** @brief     阿里云API接口集合
    @file      MARALIAPINetworkManager.h
    @author    Martin.Liu
    @version   1.0.0
    @date      2018-01-31
    @note      注解. 例如: 本文件有什么具体功能啊,使用时要注意什么啊…..
    @since     自从  例如: 自从xxx年地球爆炸后这个文件就从地球上消失了…..
  */

@interface MARALIAPINetworkManager : NSObject


/**
 @brief 获取城市
 @link https:market.aliyun.com/products/57126001/cmapi014302.html?spm=5176.2020520132.101.10.LopetC#sku=yuncode830200000
 @param success 成功回调block，形参是 MAAWeatherCityModel 的数组
 @param failure 失败回调block
 */
+ (void)weather_getCitiesSuccess:(void (^)(NSArray<MAAWeatherCityModel *> * cityArray))success
                         failure:(MARNetworkFailure)failure;


/**
 
 @brief *获取某地近一周的天气情况*
 @param param 参照 MAAGetWeatherR
 @param success 成功回调
 @param failure 失败回调
 @copyright Liulong License.
 @see 参见 weather_getCitiesSuccess:failure:
 @pre       需要先获取城市信息
 @note      注解在这里
 @warning   这是警告 \n警告第二行
                - 警告1
                - 警告2
 @attention 注意点
                -# 注意1
                -# 注意2
 
 | 错误码|                 错误信息                      |         描述
 -------|---------------------------------------------|----------------------
 | 201  | City and city ID and city code are empty    | 城市和城市ID和城市代号都为空
 | 202  | City does not exist                         |       城市不存在
 | 203  | There is no weather information in this city|   此城市没有天气信息
 | 210  | No information                              |        没有信息
 */
+ (void)weather_getWeather:(MAAGetWeatherR *)param
                   success:(void (^)(MAAWeatherModel *weatherM))success
                   failure:(MARNetworkFailure)failure;

+ (void)car_getAllBrandSuccess:(void (^)(NSArray<MAACarBrandM *>* carBrandArray))success
                       failure:(MARNetworkFailure)failure;

+ (void)car_getCarFactoriesByBrandID:(NSString *)carBrandID
                           success:(void (^)(NSArray<MAACarFactoryM *> *carFactoryArray))success
                           failure:(MARNetworkFailure)failure;

+ (void)car_getCarDetailWithCarID:(NSString *)carID
                          success:(void (^)(MAACarModel *carModel))success
                          failure:(MARNetworkFailure)failure;

+ (void)new_getNewListWithType:(NSString *)type
                       success:(void (^)(NSArray<MAANewModel *> *newArray))success
                       failure:(MARNetworkFailure)failure;


/**
 https://market.aliyun.com/products/57002003/cmapi021970.html?spm=5176.730005.productlist.d_cmapi021970.Afrjrk#sku=yuncode1597000000
 快速查询出该IP地址的归属地相关信息
 @param ip ip地址
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)ip_getLocationWithIp:(NSString *)ip
                     success:(void (^)(MAAIpLocationModel *ipLocationModel))success
                     failure:(MARNetworkFailure)failure;
@end
