//
//  MARCardBrandModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MARCarTypeInfoModel;
@interface MARCardBrandModel : MARBaseDBModel <MARModelDelegate>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<MARCarTypeInfoModel *> *son;
@end

@interface MARCarTypeInfoModel : MARBaseDBModel
@property (nonatomic, strong) NSString *car;
@property (nonatomic, strong) NSString *type;
@end

@interface MARCarSerieInfoModel : NSObject
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *guidePrice;
@property (nonatomic, strong) NSString *seriesName;
@end

