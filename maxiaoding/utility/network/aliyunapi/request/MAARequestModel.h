//
//  MAARequestModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/31.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
/** @brief     **阿里云API需要的请求参数数据模型集合**
    @file      MAARequestModel.h
    @author    Martin.Liu
    @version   1.0.0
    @date      2018-01-31
    @note      注解. 例如: 本文件有什么具体功能啊,使用时要注意什么啊…..
    @since     自从  例如: 自从xxx年地球爆炸后这个文件就从地球上消失了…..
  */

@interface MAARequestModel : NSObject

@end


/**
 -------------------------------------------------------------------------------
 | 名称       |   类型   |是否必须    | 描述
 |-----------|---------------------|--------------------------------------------
 | city      |  STRING  | 可选      | 城市（city,cityid,citycode三者任选其一）
 |-----------|---------------------|--------------------------------------------
 | citycode  |  STRING  | 可选      | 城市天气代号（city,cityid,citycode三者任选其一）
 |-----------|---------------------|--------------------------------------------
 | cityid    |  STRING  | 可选      | 城市ID（city,cityid,citycode三者任选其一）
 |-----------|---------------------|--------------------------------------------
 | ip        |  STRING  | 可选      | IP
 |-----------|---------------------|--------------------------------------------
 | location  |  STRING  | 可选      | 经纬度 纬度在前，,分割 如：39.983424,116.322987
 ----------------------------------|--------------------------------------------
 */
@interface MAAGetWeatherR : NSObject
@property (nonatomic, strong) NSString *city;       //!< 可选    城市（city,cityid,citycode三者任选其一）
@property (nonatomic, strong) NSString *citycode;   //!< 可选    城市天气代号（city,cityid,citycode三者任选其一）
@property (nonatomic, strong) NSString *cityid;     //!< 可选    城市ID（city,cityid,citycode三者任选其一）
@property (nonatomic, strong) NSString *ip;         //!< 可选    IP
@property (nonatomic, strong) NSString *location;   //!< 可选    经纬度 纬度在前，,分割 如：39.983424,116.322987
@end
