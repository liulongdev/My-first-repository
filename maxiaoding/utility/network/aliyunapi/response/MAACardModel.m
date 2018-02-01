//
//  MAACarModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/1.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAACarModel.h"

@implementation MAACarModel

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"basic": [MAACarBasicInfoM class],
             @"body": [MAACarBodyM class],
             @"engine": [MAACarEngineM class],
             @"gearbox": [MAACarGearboxM class],
             @"chassisbrake": [MAACarChassisBrake class],
             @"safe": [MAACarSafeM class],
             @"wheel": [MAACarWheelM class],
             @"drivingauxiliary": [MAACarDrivingAuxiliaryM class],
             @"doormirror": [MAACarDoorMirrorM class],
             @"light": [MAACarLightM class],
             @"internalconfig": [MAACarInternalConfigM class],
             @"seat": [MAACarSeatM class],
             @"entcom": [MAACarEntcom class],
             @"aircondrefrigerator": [MAACarAirCondrefrigerator class],
             @"actualtest": [MAACarActualtest class],
             };
}

@end

@implementation MAACarBasicInfoM

@end

@implementation MAACarBodyM : MARBaseDBModel

@end

@implementation MAACarEngineM : MARBaseDBModel

@end

@implementation MAACarGearboxM : MARBaseDBModel

@end

@implementation MAACarChassisBrake : MARBaseDBModel

@end

@implementation MAACarSafeM : MARBaseDBModel

@end

@implementation MAACarWheelM : MARBaseDBModel

@end

@implementation MAACarDrivingAuxiliaryM : MARBaseDBModel

@end

@implementation MAACarDoorMirrorM : MARBaseDBModel

@end

@implementation MAACarLightM : MARBaseDBModel

@end

@implementation MAACarInternalConfigM : MARBaseDBModel

@end

@implementation MAACarSeatM : MARBaseDBModel

@end

@implementation MAACarEntcom : MARBaseDBModel

@end

@implementation MAACarAirCondrefrigerator : MARBaseDBModel

@end

@implementation MAACarActualtest : MARBaseDBModel

@end

@implementation MAACarSimpleInfoM

@end

@implementation MAACarBrandM

@end

@implementation MAACarFactoryM

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"carlist": [MAACarTypeM class]};
}

@end

@implementation MAACarTypeM

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"list": [MAACarSimpleInfoM class]};
}

@end
