//
//  MAACarModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/1.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAACarModel.h"

@implementation NSString (MAACarDefaultValue)

- (NSString *)maa_value
{
    if (self.length == 0 || [self mar_stringByTrim].length == 0
        ) {
        return @"-";
    }
    return self;
}

@end

@implementation MAACarModel

+ (NSString *)getPrimaryKey
{
    return @"id";
}

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

+ (MAACarModel *)carModelWithCarId:(NSString *)carId
{
    NSArray<MAACarModel *> *carMArray = [[self getUsingLKDBHelper] search:[self class] where:@{@"id": carId} orderBy:nil offset:0 count:0];
    if (carMArray.count > 0) {
        return carMArray[0];
    }
    return nil;
}

@end

@implementation MAACarBasicInfoM

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *basicInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [basicInfoStr appendFormat:@"变速箱:\t\t\t%@\n", self.gearbox.maa_value];
        [basicInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement.maa_value];
        [basicInfoStr appendFormat:@"商家报价:\t\t\t%@\n", self.saleprice.maa_value];
        [basicInfoStr appendFormat:@"保修政策:\t\t\t%@\n", self.warrantypolicy.maa_value];
        [basicInfoStr appendFormat:@"车船税减免:\t\t\t%@\n", self.vechiletax.maa_value];
        [basicInfoStr appendFormat:@"厂家指导价:\t\t\t%@\n", self.price.maa_value];
        [basicInfoStr appendFormat:@"最高车速(km/h):\t\t\t%@\n", self.maxspeed.maa_value];
        [basicInfoStr appendFormat:@"乘员人数(区间)(个):\t\t\t%@\n", self.seatnum.maa_value];
        [basicInfoStr appendFormat:@"网友油耗(L/100km):\t\t\t%@\n", self.userfuelconsumption.maa_value];
        [basicInfoStr appendFormat:@"综合工况油耗(L/100km):\t\t\t%@\n", self.comfuelconsumption.maa_value];
        [basicInfoStr appendFormat:@"实测0-100公里加速时间(S):\t\t\t%@\n", self.testaccelerationtime100.maa_value];
        [basicInfoStr appendFormat:@"官方0-100公里加速时间(S):\t\t\t%@\n", self.officialaccelerationtime100.maa_value];
    }
    else
    {
        if (self.gearbox.length > 0)
            [basicInfoStr appendFormat:@"变速箱:\t\t\t%@\n", self.gearbox];
        if (self.displacement.length > 0)
            [basicInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement];
        if (self.saleprice.length > 0)
            [basicInfoStr appendFormat:@"商家报价:\t\t\t%@\n", self.saleprice];
        if (self.warrantypolicy.length > 0)
            [basicInfoStr appendFormat:@"保修政策:\t\t\t%@\n", self.warrantypolicy];
        if (self.vechiletax.length > 0)
            [basicInfoStr appendFormat:@"车船税减免:\t\t\t%@\n", self.vechiletax];
        if (self.price.length > 0)
            [basicInfoStr appendFormat:@"厂家指导价:\t\t\t%@\n", self.price];
        if (self.maxspeed.length > 0)
            [basicInfoStr appendFormat:@"最高车速(km/h):\t\t\t%@\n", self.maxspeed];
        if (self.seatnum.length > 0)
            [basicInfoStr appendFormat:@"乘员人数(区间)(个):\t\t\t%@\n", self.seatnum];
        if (self.userfuelconsumption.length > 0)
            [basicInfoStr appendFormat:@"网友油耗(L/100km):\t\t\t%@\n", self.userfuelconsumption];
        if (self.comfuelconsumption.length > 0)
            [basicInfoStr appendFormat:@"综合工况油耗(L/100km):\t\t\t%@\n", self.comfuelconsumption];
        if (self.testaccelerationtime100.length > 0)
            [basicInfoStr appendFormat:@"实测0-100公里加速时间(S):\t\t\t%@\n", self.testaccelerationtime100];
        if (self.officialaccelerationtime100.length > 0)
            [basicInfoStr appendFormat:@"官方0-100公里加速时间(S):\t\t\t%@\n", self.officialaccelerationtime100];
    }
    return basicInfoStr;
}

@end

@implementation MAACarBodyM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *bodyInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        // 车体
        [bodyInfoStr appendFormat:@"车身颜色:\t\t\t%@\n", [self.color mar_stringByReplacingRegex:@"#\\w+\\|" options:NSRegularExpressionCaseInsensitive withString:@""]];
        [bodyInfoStr appendFormat:@"车长(mm):\t\t\t%@\n", self.len.maa_value];
        [bodyInfoStr appendFormat:@"车宽(mm):\t\t\t%@\n", self.width.maa_value];
        [bodyInfoStr appendFormat:@"车高(mm):\t\t\t%@\n", self.height.maa_value];
        [bodyInfoStr appendFormat:@"轴距(mm):\t\t\t%@\n", self.wheelbase.maa_value];
        [bodyInfoStr appendFormat:@"接近角(º):\t\t\t%@\n", self.approachangle.maa_value];
        [bodyInfoStr appendFormat:@"离去角(º):\t\t\t%@\n", self.departureangle.maa_value];
        [bodyInfoStr appendFormat:@"车顶型式:\t\t\t%@\n", self.tooftype.maa_value];
        [bodyInfoStr appendFormat:@"车棚型式:\t\t\t%@\n", self.hoodtype.maa_value];
        [bodyInfoStr appendFormat:@"前轮距(mm):\t\t\t%@\n", self.fronttrack.maa_value];
        [bodyInfoStr appendFormat:@"后轮距(mm):\t\t\t%@\n", self.reartrack.maa_value];
        [bodyInfoStr appendFormat:@"整备质量(kg):\t\t\t%@\n", self.weight.maa_value];
        [bodyInfoStr appendFormat:@"满载质量(kg):\t\t\t%@\n", self.fullweight.maa_value];
        [bodyInfoStr appendFormat:@"感应行李箱:\t\t\t%@\n", self.inductionluggage.maa_value];
        [bodyInfoStr appendFormat:@"车门数(个）:\t\t\t%@\n", self.doornum.maa_value];
        [bodyInfoStr appendFormat:@"车顶行李箱架:\t\t\t%@\n", self.roofluggagerack.maa_value];
        [bodyInfoStr appendFormat:@"运动外观套件:\t\t\t%@\n", self.sportpackage.maa_value];
        [bodyInfoStr appendFormat:@"行李箱容积(L):\t\t\t%@\n", self.luggagevolume.maa_value];
        [bodyInfoStr appendFormat:@"行李箱打开方式:\t\t\t%@\n", self.luggageopenmode.maa_value];
        [bodyInfoStr appendFormat:@"行李箱盖开合方式:\t\t\t%@\n", self.luggagemode.maa_value];
        [bodyInfoStr appendFormat:@"最小离地间隙(mm):\t\t\t%@\n", self.mingroundclearance.maa_value];
    }
    else
    {
        if (self.color.length > 0)
            [bodyInfoStr appendFormat:@"车身颜色:\t\t\t%@\n", [self.color mar_stringByReplacingRegex:@"#\\w+\\|" options:NSRegularExpressionCaseInsensitive withString:@""]];
        if (self.len.length > 0)
            [bodyInfoStr appendFormat:@"车长(mm):\t\t\t%@\n", self.len.maa_value];
        if (self.width.length > 0)
            [bodyInfoStr appendFormat:@"车宽(mm):\t\t\t%@\n", self.width.maa_value];
        if (self.height.length > 0)
            [bodyInfoStr appendFormat:@"车高(mm):\t\t\t%@\n", self.height.maa_value];
        if (self.wheelbase.length > 0)
            [bodyInfoStr appendFormat:@"轴距(mm):\t\t\t%@\n", self.wheelbase.maa_value];
        if (self.approachangle.length > 0)
            [bodyInfoStr appendFormat:@"接近角(º):\t\t\t%@\n", self.approachangle.maa_value];
        if (self.departureangle.length > 0)
            [bodyInfoStr appendFormat:@"离去角(º):\t\t\t%@\n", self.departureangle.maa_value];
        if (self.tooftype.length > 0)
            [bodyInfoStr appendFormat:@"车顶型式:\t\t\t%@\n", self.tooftype.maa_value];
        if (self.hoodtype.length > 0)
            [bodyInfoStr appendFormat:@"车棚型式:\t\t\t%@\n", self.hoodtype.maa_value];
        if (self.fronttrack.length > 0)
            [bodyInfoStr appendFormat:@"前轮距(mm):\t\t\t%@\n", self.fronttrack.maa_value];
        if (self.reartrack.length > 0)
            [bodyInfoStr appendFormat:@"后轮距(mm):\t\t\t%@\n", self.reartrack.maa_value];
        if (self.weight.length > 0)
            [bodyInfoStr appendFormat:@"整备质量(kg):\t\t\t%@\n", self.weight.maa_value];
        if (self.fullweight.length > 0)
            [bodyInfoStr appendFormat:@"满载质量(kg):\t\t\t%@\n", self.fullweight.maa_value];
        if (self.inductionluggage.length > 0)
            [bodyInfoStr appendFormat:@"感应行李箱:\t\t\t%@\n", self.inductionluggage.maa_value];
        if (self.doornum.length > 0)
            [bodyInfoStr appendFormat:@"车门数(个）:\t\t\t%@\n", self.doornum.maa_value];
        if (self.roofluggagerack.length > 0)
            [bodyInfoStr appendFormat:@"车顶行李箱架:\t\t\t%@\n", self.roofluggagerack.maa_value];
        if (self.sportpackage.length > 0)
            [bodyInfoStr appendFormat:@"运动外观套件:\t\t\t%@\n", self.sportpackage.maa_value];
        if (self.luggagevolume.length > 0)
            [bodyInfoStr appendFormat:@"行李箱容积(L):\t\t\t%@\n", self.luggagevolume.maa_value];
        if (self.luggageopenmode.length > 0)
            [bodyInfoStr appendFormat:@"行李箱打开方式:\t\t\t%@\n", self.luggageopenmode.maa_value];
        if (self.luggagemode.length > 0)
            [bodyInfoStr appendFormat:@"行李箱盖开合方式:\t\t\t%@\n", self.luggagemode.maa_value];
        if (self.mingroundclearance.length > 0)
            [bodyInfoStr appendFormat:@"最小离地间隙(mm):\t\t\t%@\n", self.mingroundclearance.maa_value];
    }
    return bodyInfoStr;
}

@end

@implementation MAACarEngineM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *engineInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [engineInfoStr appendFormat:@"压缩比:\t\t\t%@\n", self.compressionratio.maa_value];
        [engineInfoStr appendFormat:@"缸径(mm):\t\t\t%@\n", self.bore.maa_value];
        [engineInfoStr appendFormat:@"缸体材料:\t\t\t%@\n", self.cylinderbodymaterial.maa_value];
        [engineInfoStr appendFormat:@"缸盖材料:\t\t\t%@\n", self.cylinderheadmaterial.maa_value];
        [engineInfoStr appendFormat:@"气缸数(个):\t\t\t%@\n", self.cylindernum.maa_value];
        [engineInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement.maa_value];
        [engineInfoStr appendFormat:@"排量(mL):\t\t\t%@\n", self.displacementml.maa_value];
        [engineInfoStr appendFormat:@"环保标准:\t\t\t%@\n", self.environmentalstandards.maa_value];
        [engineInfoStr appendFormat:@"燃油等级:\t\t\t%@\n", self.fuelgrade.maa_value];
        [engineInfoStr appendFormat:@"供油方式:\t\t\t%@\n", self.fuelmethod.maa_value];
        [engineInfoStr appendFormat:@"燃油箱容积(L):\t\t\t%@\n", self.fueltankcapacity.maa_value];
        [engineInfoStr appendFormat:@"燃油标号:\t\t\t%@\n", self.fueltype.maa_value];
        [engineInfoStr appendFormat:@"进气形式:\t\t\t%@\n", self.intakeform.maa_value];
        [engineInfoStr appendFormat:@"最大马力(Ps):\t\t\t%@\n", self.maxhorsepower.maa_value];
        [engineInfoStr appendFormat:@"最大功率(kW):\t\t\t%@\n", self.maxpower.maa_value];
        [engineInfoStr appendFormat:@"最大扭矩:\t\t\t%@\n", self.maxpowerspeed.maa_value];
        [engineInfoStr appendFormat:@"最大扭速:\t\t\t%@\n", self.maxtorquespeed.maa_value];
        [engineInfoStr appendFormat:@"发动机型号:\t\t\t%@\n", self.model.maa_value];
        [engineInfoStr appendFormat:@"发动机位置:\t\t\t%@\n", self.position.maa_value];
        [engineInfoStr appendFormat:@"启停系统:\t\t\t%@\n", self.startstopsystem.maa_value];
        [engineInfoStr appendFormat:@"行程(mm):\t\t\t%@\n", self.stroke.maa_value];
        [engineInfoStr appendFormat:@"气门结构:\t\t\t%@\n", self.valvestructure.maa_value];
        [engineInfoStr appendFormat:@"气缸排列型式:\t\t\t%@\n", self.cylinderarrangetype.maa_value];
        [engineInfoStr appendFormat:@"每缸气门数(个):\t\t\t%@\n", self.valvetrain.maa_value];
        [engineInfoStr appendFormat:@"最大功率转速(rpm):\t\t\t%@\n", self.maxpowerspeed.maa_value];
    }
    else
    {
        if (self.compressionratio.length > 0)
            [engineInfoStr appendFormat:@"压缩比:\t\t\t%@\n", self.compressionratio];
        if (self.bore.length > 0)
            [engineInfoStr appendFormat:@"缸径(mm):\t\t\t%@\n", self.bore];
        if (self.cylinderbodymaterial.length > 0)
            [engineInfoStr appendFormat:@"缸体材料:\t\t\t%@\n", self.cylinderbodymaterial];
        if (self.cylinderheadmaterial.length > 0)
            [engineInfoStr appendFormat:@"缸盖材料:\t\t\t%@\n", self.cylinderheadmaterial];
        if (self.cylindernum.length > 0)
            [engineInfoStr appendFormat:@"气缸数(个):\t\t\t%@\n", self.cylindernum];
        if (self.displacement.length > 0)
            [engineInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement];
        if (self.displacementml.length > 0)
            [engineInfoStr appendFormat:@"排量(mL):\t\t\t%@\n", self.displacementml];
        if (self.environmentalstandards.length > 0)
            [engineInfoStr appendFormat:@"环保标准:\t\t\t%@\n", self.environmentalstandards];
        if (self.fuelgrade.length > 0)
            [engineInfoStr appendFormat:@"燃油等级:\t\t\t%@\n", self.fuelgrade];
        if (self.fuelmethod.length > 0)
            [engineInfoStr appendFormat:@"供油方式:\t\t\t%@\n", self.fuelmethod];
        if (self.fueltankcapacity.length > 0)
            [engineInfoStr appendFormat:@"燃油箱容积(L):\t\t\t%@\n", self.fueltankcapacity];
        if (self.fueltype.length > 0)
            [engineInfoStr appendFormat:@"燃油标号:\t\t\t%@\n", self.fueltype];
        if (self.intakeform.length > 0)
            [engineInfoStr appendFormat:@"进气形式:\t\t\t%@\n", self.intakeform];
        if (self.maxhorsepower.length > 0)
            [engineInfoStr appendFormat:@"最大马力(Ps):\t\t\t%@\n", self.maxhorsepower];
        if (self.maxpower.length > 0)
            [engineInfoStr appendFormat:@"最大功率(kW):\t\t\t%@\n", self.maxpower];
        if (self.maxpowerspeed.length > 0)
            [engineInfoStr appendFormat:@"最大扭矩:\t\t\t%@\n", self.maxpowerspeed];
        if (self.maxtorquespeed.length > 0)
            [engineInfoStr appendFormat:@"最大扭速:\t\t\t%@\n", self.maxtorquespeed];
        if (self.model.length > 0)
            [engineInfoStr appendFormat:@"发动机型号:\t\t\t%@\n", self.model];
        if (self.position.length > 0)
            [engineInfoStr appendFormat:@"发动机位置:\t\t\t%@\n", self.position];
        if (self.startstopsystem.length > 0)
            [engineInfoStr appendFormat:@"启停系统:\t\t\t%@\n", self.startstopsystem];
        if (self.stroke.length > 0)
            [engineInfoStr appendFormat:@"行程(mm):\t\t\t%@\n", self.stroke];
        if (self.valvestructure.length > 0)
            [engineInfoStr appendFormat:@"气门结构:\t\t\t%@\n", self.valvestructure];
        if (self.cylinderarrangetype.length > 0)
            [engineInfoStr appendFormat:@"气缸排列型式:\t\t\t%@\n", self.cylinderarrangetype];
        if (self.valvetrain.length > 0)
            [engineInfoStr appendFormat:@"每缸气门数(个):\t\t\t%@\n", self.valvetrain];
        if (self.maxpowerspeed.length > 0)
            [engineInfoStr appendFormat:@"最大功率转速(rpm):\t\t\t%@\n", self.maxpowerspeed];
    }
    
    return engineInfoStr;
}

@end

@implementation MAACarGearboxM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *gearboxStr = [NSMutableString string];
    [gearboxStr appendFormat:@"变速箱:\t\t\t%@\n", self.gearbox.maa_value];
    [gearboxStr appendFormat:@"换挡拨片:\t\t\t%@\n", self.shiftpaddles.maa_value];
    return gearboxStr;
}

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

+ (NSString *)getPrimaryKey
{
    return @"id";
}

@end

@implementation MAACarSimpleInfoM

@end

@implementation MAACarBrandM

+ (NSString *)getPrimaryKey
{
    return @"id";
}

@end

@implementation MAACarFactoryM

+ (NSString *)getPrimaryKey
{
    return @"id";
}

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"carlist": [MAACarTypeM class]};
}

+ (NSArray<MAACarFactoryM *> *)carFactoryArrayWithBrandId:(NSString *)brandId
{
    NSArray *carFactoryArray = [[self getUsingLKDBHelper] search:[self class] where:@{@"parentid":brandId ?: @""} orderBy:nil offset:0 count:0];
    return carFactoryArray;
}

@end

@implementation MAACarTypeM

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"list": [MAACarSimpleInfoM class]};
}

@end
