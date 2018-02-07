//
//  MARWeatherChooseCityVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/7.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"
#import "MAAWeatherModel.h"
@interface MARWeatherChooseCityVC : MARBaseViewController

@property (nonatomic, copy) void (^selectLoalCityMBlock)(MAAWeatherLocalCityModel *localCityM);

@end
