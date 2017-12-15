//
//  MARCarBrandModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MARCarTypeInfoModel;
@interface MARCarBrandModel : MARBaseDBModel <MARModelDelegate>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<MARCarTypeInfoModel *> *son;
@end

@interface MARCarTypeInfoModel : MARBaseDBModel<NSCoding>
@property (nonatomic, strong) NSString *car;
@property (nonatomic, strong) NSString *type;
@end

@interface MARCarSerieInfoModel : NSObject
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *guidePrice;
@property (nonatomic, strong) NSString *seriesName;
@end

@interface MARCarSerieModel : MARBaseDBModel
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *guidePrice;
@property (nonatomic, strong) NSString *seriesName;

+ (NSArray <MARCarSerieModel *> *)getCardSerieArrayWithBrandName:(NSString *)brandName;

@end

@class MARCarNameValueModel;
@interface MARCarDetailModel : MARBaseDBModel<MARModelDelegate>
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *baseInfo;       // 车型基本配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *airConfig;      // 空调/冰箱配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *carbody;        // 车身配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *chassis;        // 底盘配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *controlConfig;  // 操控配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *engine;         // 发动机配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *exterConfig;    // 外部配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *glassConfig;    // 玻璃/后视镜配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *interConfig;    // 内部配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *lightConfig;    // 灯光配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *mediaConfig;    // 多媒体配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *safetyDevice;   // 安全装置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *seatConfig;     // 座椅配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *techConfig;     // 高科技配置信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *transmission;   // 变速箱信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *wheelInfo;      // 车轮制动信息
@property (nonatomic, strong) NSArray<MARCarNameValueModel *> *motorList;      // 电动机配置信息
@property (nonatomic, strong) NSString *brand;          // 品牌名称
@property (nonatomic, strong) NSString *brandName;      // 车系名称
@property (nonatomic, strong) NSString *carImage;       // 图片地址
@property (nonatomic, strong) NSString *seriesName;     // 车型名称
@property (nonatomic, strong) NSString *sonBrand;       // 子品牌或合资品牌
@end

@interface MARCarNameValueModel : MARBaseDBModel <NSCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;
@end
