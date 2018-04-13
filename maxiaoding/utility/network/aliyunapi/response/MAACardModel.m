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
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"变速箱:\t\t\t%@\n", self.gearbox.maa_value];
        [carInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement.maa_value];
        [carInfoStr appendFormat:@"商家报价:\t\t\t%@\n", self.saleprice.maa_value];
        [carInfoStr appendFormat:@"保修政策:\t\t\t%@\n", self.warrantypolicy.maa_value];
        [carInfoStr appendFormat:@"车船税减免:\t\t\t%@\n", self.vechiletax.maa_value];
        [carInfoStr appendFormat:@"厂家指导价:\t\t\t%@\n", self.price.maa_value];
        [carInfoStr appendFormat:@"最高车速(km/h):\t\t\t%@\n", self.maxspeed.maa_value];
        [carInfoStr appendFormat:@"乘员人数(区间)(个):\t\t\t%@\n", self.seatnum.maa_value];
        [carInfoStr appendFormat:@"网友油耗(L/100km):\t\t\t%@\n", self.userfuelconsumption.maa_value];
        [carInfoStr appendFormat:@"综合工况油耗(L/100km):\t\t\t%@\n", self.comfuelconsumption.maa_value];
        [carInfoStr appendFormat:@"实测0-100公里加速时间(S):\t%@\n", self.testaccelerationtime100.maa_value];
        [carInfoStr appendFormat:@"官方0-100公里加速时间(S):\t%@\n", self.officialaccelerationtime100.maa_value];
    }
    else
    {
        if (self.gearbox.length > 0)
            [carInfoStr appendFormat:@"变速箱:\t\t\t%@\n", self.gearbox];
        if (self.displacement.length > 0)
            [carInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement];
        if (self.saleprice.length > 0)
            [carInfoStr appendFormat:@"商家报价:\t\t\t%@\n", self.saleprice];
        if (self.warrantypolicy.length > 0)
            [carInfoStr appendFormat:@"保修政策:\t\t\t%@\n", self.warrantypolicy];
        if (self.vechiletax.length > 0)
            [carInfoStr appendFormat:@"车船税减免:\t\t\t%@\n", self.vechiletax];
        if (self.price.length > 0)
            [carInfoStr appendFormat:@"厂家指导价:\t\t\t%@\n", self.price];
        if (self.maxspeed.length > 0)
            [carInfoStr appendFormat:@"最高车速(km/h):\t\t\t%@\n", self.maxspeed];
        if (self.seatnum.length > 0)
            [carInfoStr appendFormat:@"乘员人数(区间)(个):\t\t\t%@\n", self.seatnum];
        if (self.userfuelconsumption.length > 0)
            [carInfoStr appendFormat:@"网友油耗(L/100km):\t\t\t%@\n", self.userfuelconsumption];
        if (self.comfuelconsumption.length > 0)
            [carInfoStr appendFormat:@"综合工况油耗(L/100km):\t\t\t%@\n", self.comfuelconsumption];
        if (self.testaccelerationtime100.length > 0)
            [carInfoStr appendFormat:@"实测0-100公里加速时间(S):\t%@\n", self.testaccelerationtime100];
        if (self.officialaccelerationtime100.length > 0)
            [carInfoStr appendFormat:@"官方0-100公里加速时间(S):\t%@\n", self.officialaccelerationtime100];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarBodyM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        // 车体
        [carInfoStr appendFormat:@"车身颜色:\t\t\t%@\n", [self.color mar_stringByReplacingRegex:@"#\\w+\\|" options:NSRegularExpressionCaseInsensitive withString:@""]];
        [carInfoStr appendFormat:@"车长(mm):\t\t\t%@\n", self.len.maa_value];
        [carInfoStr appendFormat:@"车宽(mm):\t\t\t%@\n", self.width.maa_value];
        [carInfoStr appendFormat:@"车高(mm):\t\t\t%@\n", self.height.maa_value];
        [carInfoStr appendFormat:@"轴距(mm):\t\t\t%@\n", self.wheelbase.maa_value];
        [carInfoStr appendFormat:@"接近角(º):\t\t\t%@\n", self.approachangle.maa_value];
        [carInfoStr appendFormat:@"离去角(º):\t\t\t%@\n", self.departureangle.maa_value];
        [carInfoStr appendFormat:@"车顶型式:\t\t\t%@\n", self.tooftype.maa_value];
        [carInfoStr appendFormat:@"车棚型式:\t\t\t%@\n", self.hoodtype.maa_value];
        [carInfoStr appendFormat:@"前轮距(mm):\t\t\t%@\n", self.fronttrack.maa_value];
        [carInfoStr appendFormat:@"后轮距(mm):\t\t\t%@\n", self.reartrack.maa_value];
        [carInfoStr appendFormat:@"整备质量(kg):\t\t\t%@\n", self.weight.maa_value];
        [carInfoStr appendFormat:@"满载质量(kg):\t\t\t%@\n", self.fullweight.maa_value];
        [carInfoStr appendFormat:@"感应行李箱:\t\t\t%@\n", self.inductionluggage.maa_value];
        [carInfoStr appendFormat:@"车门数(个）:\t\t\t%@\n", self.doornum.maa_value];
        [carInfoStr appendFormat:@"车顶行李箱架:\t\t\t%@\n", self.roofluggagerack.maa_value];
        [carInfoStr appendFormat:@"运动外观套件:\t\t\t%@\n", self.sportpackage.maa_value];
        [carInfoStr appendFormat:@"行李箱容积(L):\t\t\t%@\n", self.luggagevolume.maa_value];
        [carInfoStr appendFormat:@"行李箱打开方式:\t\t\t%@\n", self.luggageopenmode.maa_value];
        [carInfoStr appendFormat:@"行李箱盖开合方式:\t\t\t%@\n", self.luggagemode.maa_value];
        [carInfoStr appendFormat:@"最小离地间隙(mm):\t\t\t%@\n", self.mingroundclearance.maa_value];
    }
    else
    {
        if (self.color.length > 0)
            [carInfoStr appendFormat:@"车身颜色:\t\t\t%@\n", [self.color mar_stringByReplacingRegex:@"#\\w+\\|" options:NSRegularExpressionCaseInsensitive withString:@""]];
        if (self.len.length > 0)
            [carInfoStr appendFormat:@"车长(mm):\t\t\t%@\n", self.len.maa_value];
        if (self.width.length > 0)
            [carInfoStr appendFormat:@"车宽(mm):\t\t\t%@\n", self.width.maa_value];
        if (self.height.length > 0)
            [carInfoStr appendFormat:@"车高(mm):\t\t\t%@\n", self.height.maa_value];
        if (self.wheelbase.length > 0)
            [carInfoStr appendFormat:@"轴距(mm):\t\t\t%@\n", self.wheelbase.maa_value];
        if (self.approachangle.length > 0)
            [carInfoStr appendFormat:@"接近角(º):\t\t\t%@\n", self.approachangle.maa_value];
        if (self.departureangle.length > 0)
            [carInfoStr appendFormat:@"离去角(º):\t\t\t%@\n", self.departureangle.maa_value];
        if (self.tooftype.length > 0)
            [carInfoStr appendFormat:@"车顶型式:\t\t\t%@\n", self.tooftype.maa_value];
        if (self.hoodtype.length > 0)
            [carInfoStr appendFormat:@"车棚型式:\t\t\t%@\n", self.hoodtype.maa_value];
        if (self.fronttrack.length > 0)
            [carInfoStr appendFormat:@"前轮距(mm):\t\t\t%@\n", self.fronttrack.maa_value];
        if (self.reartrack.length > 0)
            [carInfoStr appendFormat:@"后轮距(mm):\t\t\t%@\n", self.reartrack.maa_value];
        if (self.weight.length > 0)
            [carInfoStr appendFormat:@"整备质量(kg):\t\t\t%@\n", self.weight.maa_value];
        if (self.fullweight.length > 0)
            [carInfoStr appendFormat:@"满载质量(kg):\t\t\t%@\n", self.fullweight.maa_value];
        if (self.inductionluggage.length > 0)
            [carInfoStr appendFormat:@"感应行李箱:\t\t\t%@\n", self.inductionluggage.maa_value];
        if (self.doornum.length > 0)
            [carInfoStr appendFormat:@"车门数(个）:\t\t\t%@\n", self.doornum.maa_value];
        if (self.roofluggagerack.length > 0)
            [carInfoStr appendFormat:@"车顶行李箱架:\t\t\t%@\n", self.roofluggagerack.maa_value];
        if (self.sportpackage.length > 0)
            [carInfoStr appendFormat:@"运动外观套件:\t\t\t%@\n", self.sportpackage.maa_value];
        if (self.luggagevolume.length > 0)
            [carInfoStr appendFormat:@"行李箱容积(L):\t\t\t%@\n", self.luggagevolume.maa_value];
        if (self.luggageopenmode.length > 0)
            [carInfoStr appendFormat:@"行李箱打开方式:\t\t\t%@\n", self.luggageopenmode.maa_value];
        if (self.luggagemode.length > 0)
            [carInfoStr appendFormat:@"行李箱盖开合方式:\t\t\t%@\n", self.luggagemode.maa_value];
        if (self.mingroundclearance.length > 0)
            [carInfoStr appendFormat:@"最小离地间隙(mm):\t\t\t%@\n", self.mingroundclearance.maa_value];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarEngineM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"压缩比:\t\t\t%@\n", self.compressionratio.maa_value];
        [carInfoStr appendFormat:@"缸体材料:\t\t\t%@\n", self.cylinderbodymaterial.maa_value];
        [carInfoStr appendFormat:@"缸盖材料:\t\t\t%@\n", self.cylinderheadmaterial.maa_value];
        [carInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement.maa_value];
        [carInfoStr appendFormat:@"排量(mL):\t\t\t%@\n", self.displacementml.maa_value];
        [carInfoStr appendFormat:@"缸径(mm):\t\t\t%@\n", self.bore.maa_value];
        [carInfoStr appendFormat:@"环保标准:\t\t\t%@\n", self.environmentalstandards.maa_value];
        [carInfoStr appendFormat:@"燃油等级:\t\t\t%@\n", self.fuelgrade.maa_value];
        [carInfoStr appendFormat:@"供油方式:\t\t\t%@\n", self.fuelmethod.maa_value];
        [carInfoStr appendFormat:@"燃油标号:\t\t\t%@\n", self.fueltype.maa_value];
        [carInfoStr appendFormat:@"进气形式:\t\t\t%@\n", self.intakeform.maa_value];
        [carInfoStr appendFormat:@"最大扭矩:\t\t\t%@\n", self.maxpowerspeed.maa_value];
        [carInfoStr appendFormat:@"最大扭速:\t\t\t%@\n", self.maxtorquespeed.maa_value];
        [carInfoStr appendFormat:@"启停系统:\t\t\t%@\n", self.startstopsystem.maa_value];
        [carInfoStr appendFormat:@"行程(mm):\t\t\t%@\n", self.stroke.maa_value];
        [carInfoStr appendFormat:@"气门结构:\t\t\t%@\n", self.valvestructure.maa_value];
        [carInfoStr appendFormat:@"气缸数(个):\t\t\t%@\n", self.cylindernum.maa_value];
        [carInfoStr appendFormat:@"发动机型号:\t\t\t%@\n", self.model.maa_value];
        [carInfoStr appendFormat:@"发动机位置:\t\t\t%@\n", self.position.maa_value];
        [carInfoStr appendFormat:@"最大马力(Ps):\t\t\t%@\n", self.maxhorsepower.maa_value];
        [carInfoStr appendFormat:@"最大功率(kW):\t\t\t%@\n", self.maxpower.maa_value];
        [carInfoStr appendFormat:@"气缸排列型式:\t\t\t%@\n", self.cylinderarrangetype.maa_value];
        [carInfoStr appendFormat:@"燃油箱容积(L):\t\t\t%@\n", self.fueltankcapacity.maa_value];
        [carInfoStr appendFormat:@"每缸气门数(个):\t\t\t%@\n", self.valvetrain.maa_value];
        [carInfoStr appendFormat:@"最大功率转速(rpm):\t\t\t%@\n", self.maxpowerspeed.maa_value];
    }
    else
    {
        if (self.compressionratio.length > 0)
            [carInfoStr appendFormat:@"压缩比:\t\t\t%@\n", self.compressionratio];
        if (self.cylinderbodymaterial.length > 0)
            [carInfoStr appendFormat:@"缸体材料:\t\t\t%@\n", self.cylinderbodymaterial];
        if (self.cylinderheadmaterial.length > 0)
            [carInfoStr appendFormat:@"缸盖材料:\t\t\t%@\n", self.cylinderheadmaterial];
        if (self.displacement.length > 0)
            [carInfoStr appendFormat:@"排量(L):\t\t\t%@\n", self.displacement];
        if (self.displacementml.length > 0)
            [carInfoStr appendFormat:@"排量(mL):\t\t\t%@\n", self.displacementml];
        if (self.bore.length > 0)
            [carInfoStr appendFormat:@"缸径(mm):\t\t\t%@\n", self.bore];
        if (self.environmentalstandards.length > 0)
            [carInfoStr appendFormat:@"环保标准:\t\t\t%@\n", self.environmentalstandards];
        if (self.fuelgrade.length > 0)
            [carInfoStr appendFormat:@"燃油等级:\t\t\t%@\n", self.fuelgrade];
        if (self.fuelmethod.length > 0)
            [carInfoStr appendFormat:@"供油方式:\t\t\t%@\n", self.fuelmethod];
        if (self.fueltype.length > 0)
            [carInfoStr appendFormat:@"燃油标号:\t\t\t%@\n", self.fueltype];
        if (self.intakeform.length > 0)
            [carInfoStr appendFormat:@"进气形式:\t\t\t%@\n", self.intakeform];
        if (self.cylindernum.length > 0)
            [carInfoStr appendFormat:@"气缸数(个):\t\t\t%@\n", self.cylindernum];
        if (self.maxpowerspeed.length > 0)
            [carInfoStr appendFormat:@"最大扭矩:\t\t\t%@\n", self.maxpowerspeed];
        if (self.maxtorquespeed.length > 0)
            [carInfoStr appendFormat:@"最大扭速:\t\t\t%@\n", self.maxtorquespeed];
        if (self.startstopsystem.length > 0)
            [carInfoStr appendFormat:@"启停系统:\t\t\t%@\n", self.startstopsystem];
        if (self.valvestructure.length > 0)
            [carInfoStr appendFormat:@"气门结构:\t\t\t%@\n", self.valvestructure];
        if (self.stroke.length > 0)
            [carInfoStr appendFormat:@"行程(mm):\t\t\t%@\n", self.stroke];
        if (self.model.length > 0)
            [carInfoStr appendFormat:@"发动机型号:\t\t\t%@\n", self.model];
        if (self.position.length > 0)
            [carInfoStr appendFormat:@"发动机位置:\t\t\t%@\n", self.position];
        if (self.cylinderarrangetype.length > 0)
            [carInfoStr appendFormat:@"气缸排列型式:\t\t\t%@\n", self.cylinderarrangetype];
        if (self.maxhorsepower.length > 0)
            [carInfoStr appendFormat:@"最大马力(Ps):\t\t\t%@\n", self.maxhorsepower];
        if (self.maxpower.length > 0)
            [carInfoStr appendFormat:@"最大功率(kW):\t\t\t%@\n", self.maxpower];
        if (self.fueltankcapacity.length > 0)
            [carInfoStr appendFormat:@"燃油箱容积(L):\t\t\t%@\n", self.fueltankcapacity];
        if (self.valvetrain.length > 0)
            [carInfoStr appendFormat:@"每缸气门数(个):\t\t\t%@\n", self.valvetrain];
        if (self.maxpowerspeed.length > 0)
            [carInfoStr appendFormat:@"最大功率转速(rpm):\t\t\t%@\n", self.maxpowerspeed];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarGearboxM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    [carInfoStr appendFormat:@"变速箱:\t\t\t%@\n", self.gearbox.maa_value];
    [carInfoStr appendFormat:@"换挡拨片:\t\t\t%@\n", self.shiftpaddles.maa_value];
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarChassisBrake : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"可调悬挂:\t\t\t%@\n", self.adjustablesuspension.maa_value];
        [carInfoStr appendFormat:@"空气悬挂:\t\t\t%@\n", self.airsuspension.maa_value];
        [carInfoStr appendFormat:@"车体结构:\t\t\t%@\n", self.bodystructure.maa_value];
        [carInfoStr appendFormat:@"驱动方式:\t\t\t%@\n", self.drivemode.maa_value];
        [carInfoStr appendFormat:@"转向助力:\t\t\t%@\n", self.powersteering.maa_value];
        [carInfoStr appendFormat:@"后制动类型:\t\t\t%@\n", self.rearbraketype.maa_value];
        [carInfoStr appendFormat:@"后悬挂类型:\t\t\t%@\n", self.rearsuspensiontype.maa_value];
        [carInfoStr appendFormat:@"前制动类型:\t\t\t%@\n", self.frontbraketype.maa_value];
        [carInfoStr appendFormat:@"前悬挂类型:\t\t\t%@\n", self.frontsuspensiontype.maa_value];
        [carInfoStr appendFormat:@"驻车制动类型:\t\t\t%@\n", self.parkingbraketype.maa_value];
        [carInfoStr appendFormat:@"中央差速器锁:\t\t\t%@\n", self.centerdifferentiallock.maa_value];
    }
    else
    {
        if (self.adjustablesuspension.length > 0)
            [carInfoStr appendFormat:@"可调悬挂:\t\t\t%@\n", self.adjustablesuspension];
        if (self.airsuspension.length > 0)
            [carInfoStr appendFormat:@"空气悬挂:\t\t\t%@\n", self.airsuspension];
        if (self.bodystructure.length > 0)
            [carInfoStr appendFormat:@"车体结构:\t\t\t%@\n", self.bodystructure];
        if (self.drivemode.length > 0)
            [carInfoStr appendFormat:@"驱动方式:\t\t\t%@\n", self.drivemode];
        if (self.powersteering.length > 0)
            [carInfoStr appendFormat:@"转向助力:\t\t\t%@\n", self.powersteering];
        if (self.rearbraketype.length > 0)
            [carInfoStr appendFormat:@"后制动类型:\t\t\t%@\n", self.rearbraketype];
        if (self.rearsuspensiontype.length > 0)
            [carInfoStr appendFormat:@"后悬挂类型:\t\t\t%@\n", self.rearsuspensiontype];
        if (self.frontbraketype.length > 0)
            [carInfoStr appendFormat:@"前制动类型:\t\t\t%@\n", self.frontbraketype];
        if (self.frontbraketype.length > 0)
            [carInfoStr appendFormat:@"前悬挂类型:\t\t\t%@\n", self.frontsuspensiontype];
        if (self.parkingbraketype.length > 0)
            [carInfoStr appendFormat:@"驻车制动类型:\t\t\t%@\n", self.parkingbraketype];
        if (self.centerdifferentiallock.length > 0)
            [carInfoStr appendFormat:@"中央差速器锁:\t\t\t%@\n", self.centerdifferentiallock];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarSafeM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"儿童锁:\t\t\t%@\n", self.childlock.maa_value];
        [carInfoStr appendFormat:@"膝部气囊:\t\t\t%@\n", self.airbagknee.maa_value];
        [carInfoStr appendFormat:@"中控门锁:\t\t\t%@\n", self.centrallocking.maa_value];
        [carInfoStr appendFormat:@"遥控钥匙:\t\t\t%@\n", self.remotekey.maa_value];
        [carInfoStr appendFormat:@"后排安全带:\t\t\t%@\n", self.rearsafetybelt.maa_value];
        [carInfoStr appendFormat:@"前安全带调节:\t\t\t%@\n", self.frontsafetybeltadjustment.maa_value];
        [carInfoStr appendFormat:@"胎压监测装置:\t\t\t%@\n", self.tirepressuremonitoring.maa_value];
        [carInfoStr appendFormat:@"安全带未系提示:\t\t\t%@\n", self.safetybeltprompt.maa_value];
        [carInfoStr appendFormat:@"驾驶位安全气囊:\t\t\t%@\n", self.airbagdrivingposition.maa_value];
        [carInfoStr appendFormat:@"副驾驶安全气囊:\t\t\t%@\n", self.airbagfrontpassenger.maa_value];
        [carInfoStr appendFormat:@"前排侧安全气囊:\t\t\t%@\n", self.airbagfrontside.maa_value];
        [carInfoStr appendFormat:@"后排侧安全气囊:\t\t\t%@\n", self.airbagrearside.maa_value];
        [carInfoStr appendFormat:@"发动机电子防盗:\t\t\t%@\n", self.engineantitheft.maa_value];
        [carInfoStr appendFormat:@"无钥匙进入系统:\t\t\t%@\n", self.keylessentry.maa_value];
        [carInfoStr appendFormat:@"无钥匙启动系统:\t\t\t%@\n", self.keylessstart.maa_value];
        [carInfoStr appendFormat:@"安全带限力功能:\t\t\t%@\n", self.safetybeltlimiting.maa_value];
        [carInfoStr appendFormat:@"安全带预收紧功能:\t\t\t%@\n", self.safetybeltpretightening.maa_value];
        [carInfoStr appendFormat:@"前排头部气囊(气帘):\t\t\t%@\n", self.airbagfronthead.maa_value];
        [carInfoStr appendFormat:@"后排头部气囊(气帘):\t\t\t%@\n", self.airbagrearhead.maa_value];
        [carInfoStr appendFormat:@"零压续航(零胎压继续行驶):\t%@\n", self.zeropressurecontinued.maa_value];
    }
    else
    {
        if (self.childlock.length > 0)
            [carInfoStr appendFormat:@"儿童锁:\t\t\t%@\n", self.childlock];
        if (self.airbagknee.length > 0)
            [carInfoStr appendFormat:@"膝部气囊:\t\t\t%@\n", self.airbagknee];
        if (self.centrallocking.length > 0)
            [carInfoStr appendFormat:@"中控门锁:\t\t\t%@\n", self.centrallocking];
        if (self.remotekey.length > 0)
            [carInfoStr appendFormat:@"遥控钥匙:\t\t\t%@\n", self.remotekey];
        if (self.rearsafetybelt.length > 0)
            [carInfoStr appendFormat:@"后排安全带:\t\t\t%@\n", self.rearsafetybelt];
        if (self.frontsafetybeltadjustment.length > 0)
            [carInfoStr appendFormat:@"前安全带调节:\t\t\t%@\n", self.frontsafetybeltadjustment];
        if (self.tirepressuremonitoring.length > 0)
            [carInfoStr appendFormat:@"胎压监测装置:\t\t\t%@\n", self.tirepressuremonitoring];
        if (self.safetybeltprompt.length > 0)
            [carInfoStr appendFormat:@"安全带未系提示:\t\t\t%@\n", self.safetybeltprompt];
        if (self.airbagdrivingposition.length > 0)
            [carInfoStr appendFormat:@"驾驶位安全气囊:\t\t\t%@\n", self.airbagdrivingposition];
        if (self.airbagfrontpassenger.length > 0)
            [carInfoStr appendFormat:@"副驾驶安全气囊:\t\t\t%@\n", self.airbagfrontpassenger];
        if (self.airbagfrontside.length > 0)
            [carInfoStr appendFormat:@"前排侧安全气囊:\t\t\t%@\n", self.airbagfrontside];
        if (self.airbagrearside.length > 0)
            [carInfoStr appendFormat:@"后排侧安全气囊:\t\t\t%@\n", self.airbagrearside];
        if (self.engineantitheft.length > 0)
            [carInfoStr appendFormat:@"发动机电子防盗:\t\t\t%@\n", self.engineantitheft];
        if (self.keylessentry.length > 0)
            [carInfoStr appendFormat:@"无钥匙进入系统:\t\t\t%@\n", self.keylessentry];
        if (self.keylessstart.length > 0)
            [carInfoStr appendFormat:@"无钥匙启动系统:\t\t\t%@\n", self.keylessstart];
        if (self.safetybeltlimiting.length > 0)
            [carInfoStr appendFormat:@"安全带限力功能:\t\t\t%@\n", self.safetybeltlimiting];
        if (self.safetybeltpretightening.length > 0)
            [carInfoStr appendFormat:@"安全带预收紧功能:\t\t\t%@\n", self.safetybeltpretightening];
        if (self.airbagfronthead.length > 0)
            [carInfoStr appendFormat:@"前排头部气囊(气帘):\t\t\t%@\n", self.airbagfronthead];
        if (self.airbagrearhead.length > 0)
            [carInfoStr appendFormat:@"后排头部气囊(气帘):\t\t\t%@\n", self.airbagrearhead];
        if (self.zeropressurecontinued.length > 0)
            [carInfoStr appendFormat:@"零压续航(零胎压继续行驶):\t%@\n", self.zeropressurecontinued];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarWheelM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"轮毂材料:\t\t\t%@\n", self.hubmaterial];
        [carInfoStr appendFormat:@"备胎类型:\t\t\t%@\n", self.sparetiretype];
        [carInfoStr appendFormat:@"前轮胎规格:\t\t\t%@\n", self.fronttiresize];
        [carInfoStr appendFormat:@"后轮胎规格:\t\t\t%@\n", self.reartiresize];
    }
    else
    {
        if (self.hubmaterial.length > 0)
            [carInfoStr appendFormat:@"轮毂材料:\t\t\t%@\n", self.hubmaterial];
        if (self.sparetiretype.length > 0)
            [carInfoStr appendFormat:@"备胎类型:\t\t\t%@\n", self.sparetiretype];
        if (self.fronttiresize.length > 0)
            [carInfoStr appendFormat:@"前轮胎规格:\t\t\t%@\n", self.fronttiresize];
        if (self.reartiresize.length > 0)
            [carInfoStr appendFormat:@"后轮胎规格:\t\t\t%@\n", self.reartiresize];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarDrivingAuxiliaryM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"自动驻车:\t\t\t%@\n", self.automaticparking.maa_value];
        [carInfoStr appendFormat:@"盲点检测:\t\t\t%@\n", self.blindspotdetection.maa_value];
        [carInfoStr appendFormat:@"定速巡航:\t\t\t%@\n", self.cruisecontrol.maa_value];
        [carInfoStr appendFormat:@"陡坡缓降:\t\t\t%@\n", self.hilldescent.maa_value];
        [carInfoStr appendFormat:@"上坡辅助:\t\t\t%@\n", self.hillstartassist.maa_value];
        [carInfoStr appendFormat:@"夜视系统:\t\t\t%@\n", self.nightvisionsystem.maa_value];
        [carInfoStr appendFormat:@"倒车影像:\t\t\t%@\n", self.reverseimage.maa_value];
        [carInfoStr appendFormat:@"自适应巡航:\t\t\t%@\n", self.adaptivecruise.maa_value];
        [carInfoStr appendFormat:@"全景摄像头:\t\t\t%@\n", self.panoramiccamera.maa_value];
        [carInfoStr appendFormat:@"GPS导航系统:\t\t\t%@\n", self.gps.maa_value];
        [carInfoStr appendFormat:@"自动泊车入位:\t\t\t%@\n", self.automaticparkingintoplace.maa_value];
        [carInfoStr appendFormat:@"泊车雷达(车前):\t\t\t%@\n", self.frontparkingradar.maa_value];
        [carInfoStr appendFormat:@"倒车雷达(车后):\t\t\t%@\n", self.reversingradar.maa_value];
        [carInfoStr appendFormat:@"整体主动转向系统:\t\t\t%@\n", self.integralactivesteering.maa_value];
        [carInfoStr appendFormat:@"车道偏离预警系统:\t\t\t%@\n", self.ldws.maa_value];
        [carInfoStr appendFormat:@"刹车防抱死(ABS):\t\t\t%@\n", self.abs.maa_value];
        [carInfoStr appendFormat:@"自动刹车/主动安全系统:\t\t\t%@\n", self.activebraking.maa_value];
        [carInfoStr appendFormat:@"随速助力转向调节(EPS):\t\t\t%@\n", self.eps.maa_value];
        [carInfoStr appendFormat:@"动力稳定控制系统(EPS):\t\t\t%@\n", self.esp.maa_value];
        [carInfoStr appendFormat:@"电子制动力分配系统(EBD):\t\t\t%@\n", self.ebd.maa_value];
        [carInfoStr appendFormat:@"刹车辅助(EBA/BAS/BA/EVA等):\t%@\n", self.brakeassist.maa_value];
        [carInfoStr appendFormat:@"牵引力控制(ASR/TCS/TRC/ATC等):\t%@\n", self.tractioncontrol.maa_value];
    }
    else
    {
        if (self.automaticparking.length > 0)
            [carInfoStr appendFormat:@"自动驻车:\t\t\t%@\n", self.automaticparking];
        if (self.blindspotdetection.length > 0)
            [carInfoStr appendFormat:@"盲点检测:\t\t\t%@\n", self.blindspotdetection];
        if (self.cruisecontrol.length > 0)
            [carInfoStr appendFormat:@"定速巡航:\t\t\t%@\n", self.cruisecontrol];
        if (self.hilldescent.length > 0)
            [carInfoStr appendFormat:@"陡坡缓降:\t\t\t%@\n", self.hilldescent];
        if (self.hillstartassist.length > 0)
            [carInfoStr appendFormat:@"上坡辅助:\t\t\t%@\n", self.hillstartassist];
        if (self.nightvisionsystem.length > 0)
            [carInfoStr appendFormat:@"夜视系统:\t\t\t%@\n", self.nightvisionsystem];
        if (self.reverseimage.length > 0)
            [carInfoStr appendFormat:@"倒车影像:\t\t\t%@\n", self.reverseimage];
        if (self.adaptivecruise.length > 0)
            [carInfoStr appendFormat:@"自适应巡航:\t\t\t%@\n", self.adaptivecruise];
        if (self.panoramiccamera.length > 0)
            [carInfoStr appendFormat:@"全景摄像头:\t\t\t%@\n", self.panoramiccamera];
        if (self.gps.length > 0)
            [carInfoStr appendFormat:@"GPS导航系统:\t\t\t%@\n", self.gps];
        if (self.automaticparkingintoplace.length > 0)
            [carInfoStr appendFormat:@"自动泊车入位:\t\t\t%@\n", self.automaticparkingintoplace];
        if (self.frontparkingradar.length > 0)
            [carInfoStr appendFormat:@"泊车雷达(车前):\t\t\t%@\n", self.frontparkingradar];
        if (self.reversingradar.length > 0)
            [carInfoStr appendFormat:@"倒车雷达(车后):\t\t\t%@\n", self.reversingradar];
        if (self.integralactivesteering.length > 0)
            [carInfoStr appendFormat:@"整体主动转向系统:\t\t\t%@\n", self.integralactivesteering];
        if (self.ldws.length > 0)
            [carInfoStr appendFormat:@"车道偏离预警系统:\t\t\t%@\n", self.ldws];
        if (self.abs.length > 0)
            [carInfoStr appendFormat:@"刹车防抱死(ABS):\t\t\t%@\n", self.abs];
        if (self.activebraking.length > 0)
            [carInfoStr appendFormat:@"自动刹车/主动安全系统:\t\t\t%@\n", self.activebraking];
        if (self.eps.length > 0)
            [carInfoStr appendFormat:@"随速助力转向调节(EPS):\t\t\t%@\n", self.eps];
        if (self.esp.length > 0)
            [carInfoStr appendFormat:@"动力稳定控制系统(EPS):\t\t\t%@\n", self.esp];
        if (self.ebd.length > 0)
            [carInfoStr appendFormat:@"电子制动力分配系统(EBD):\t\t\t%@\n", self.ebd];
        if (self.brakeassist.length > 0)
            [carInfoStr appendFormat:@"刹车辅助(EBA/BAS/BA/EVA等):\t%@\n", self.brakeassist];
        if (self.tractioncontrol.length > 0)
            [carInfoStr appendFormat:@"牵引力控制(ASR/TCS/TRC/ATC等):\t%@\n", self.tractioncontrol];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarDoorMirrorM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"电动门窗:\t\t\t%@\n", self.electricwindow.maa_value];
        [carInfoStr appendFormat:@"开门方式:\t\t\t%@\n", self.openstyle.maa_value];
        [carInfoStr appendFormat:@"隐私玻璃:\t\t\t%@\n", self.privacyglass.maa_value];
        [carInfoStr appendFormat:@"后雨刷器:\t\t\t%@\n", self.rearwiper.maa_value];
        [carInfoStr appendFormat:@"感应雨刷:\t\t\t%@\n", self.sensingwiper.maa_value];
        [carInfoStr appendFormat:@"天窗型式:\t\t\t%@\n", self.skylightstype.maa_value];
        [carInfoStr appendFormat:@"电动吸合门:\t\t\t%@\n", self.electricpulldoor.maa_value];
        [carInfoStr appendFormat:@"侧窗遮阳帘:\t\t\t%@\n", self.rearsidesunshade.maa_value];
        [carInfoStr appendFormat:@"后窗遮阳帘:\t\t\t%@\n", self.rearwindowsunshade.maa_value];
        [carInfoStr appendFormat:@"天窗开喝模式:\t\t\t%@\n", self.skylightopeningmode.maa_value];
        [carInfoStr appendFormat:@"遮阳板化妆镜:\t\t\t%@\n", self.sunvisormirror.maa_value];
        [carInfoStr appendFormat:@"电动窗防夹功能:\t\t\t%@\n", self.antipinchwindow.maa_value];
        [carInfoStr appendFormat:@"外后视镜电动调节:\t\t\t%@\n", self.externalmirroradjustment.maa_value];
        [carInfoStr appendFormat:@"外后视镜加热功能:\t\t\t%@\n", self.externalmirrorheating.maa_value];
        [carInfoStr appendFormat:@"外后视镜记忆功能:\t\t\t%@\n", self.externalmirrormemory.maa_value];
        [carInfoStr appendFormat:@"后视镜带侧转向灯:\t\t\t%@\n", self.rearmirrorwithturnlamp.maa_value];
        [carInfoStr appendFormat:@"防紫外线/隔热玻璃:\t\t\t%@\n", self.uvinterceptingglass.maa_value];
        [carInfoStr appendFormat:@"内后视镜防眩目功能:\t\t\t%@\n", self.rearviewmirrorantiglare.maa_value];
        [carInfoStr appendFormat:@"//!< 外后视镜电动折叠功能:\t\t\t%@\n", self.externalmirrorfolding.maa_value];
    }
    else
    {
        if (self.electricwindow.length > 0)
            [carInfoStr appendFormat:@"电动门窗:\t\t\t%@\n", self.electricwindow];
        if (self.openstyle.length > 0)
            [carInfoStr appendFormat:@"开门方式:\t\t\t%@\n", self.openstyle];
        if (self.privacyglass.length > 0)
            [carInfoStr appendFormat:@"隐私玻璃:\t\t\t%@\n", self.privacyglass];
        if (self.rearwiper.length > 0)
            [carInfoStr appendFormat:@"后雨刷器:\t\t\t%@\n", self.rearwiper];
        if (self.sensingwiper.length > 0)
            [carInfoStr appendFormat:@"感应雨刷:\t\t\t%@\n", self.sensingwiper];
        if (self.skylightstype.length > 0)
            [carInfoStr appendFormat:@"天窗型式:\t\t\t%@\n", self.skylightstype];
        if (self.electricpulldoor.length > 0)
            [carInfoStr appendFormat:@"电动吸合门:\t\t\t%@\n", self.electricpulldoor];
        if (self.rearsidesunshade.length > 0)
            [carInfoStr appendFormat:@"侧窗遮阳帘:\t\t\t%@\n", self.rearsidesunshade];
        if (self.rearwindowsunshade.length > 0)
            [carInfoStr appendFormat:@"后窗遮阳帘:\t\t\t%@\n", self.rearwindowsunshade];
        if (self.skylightopeningmode.length > 0)
            [carInfoStr appendFormat:@"天窗开喝模式:\t\t\t%@\n", self.skylightopeningmode];
        if (self.sunvisormirror.length > 0)
            [carInfoStr appendFormat:@"遮阳板化妆镜:\t\t\t%@\n", self.sunvisormirror];
        if (self.antipinchwindow.length > 0)
            [carInfoStr appendFormat:@"电动窗防夹功能:\t\t\t%@\n", self.antipinchwindow];
        if (self.externalmirroradjustment.length > 0)
            [carInfoStr appendFormat:@"外后视镜电动调节:\t\t\t%@\n", self.externalmirroradjustment];
        if (self.externalmirrorheating.length > 0)
            [carInfoStr appendFormat:@"外后视镜加热功能:\t\t\t%@\n", self.externalmirrorheating];
        if (self.externalmirrormemory.length > 0)
            [carInfoStr appendFormat:@"外后视镜记忆功能:\t\t\t%@\n", self.externalmirrormemory];
        if (self.rearmirrorwithturnlamp.length > 0)
            [carInfoStr appendFormat:@"后视镜带侧转向灯:\t\t\t%@\n", self.rearmirrorwithturnlamp];
        if (self.uvinterceptingglass.length > 0)
            [carInfoStr appendFormat:@"防紫外线/隔热玻璃:\t\t\t%@\n", self.uvinterceptingglass];
        if (self.rearviewmirrorantiglare.length > 0)
            [carInfoStr appendFormat:@"内后视镜防眩目功能:\t\t\t%@\n", self.rearviewmirrorantiglare];
        if (self.externalmirrorfolding.length > 0)
            [carInfoStr appendFormat:@"//!< 外后视镜电动折叠功能:\t\t\t%@\n", self.externalmirrorfolding];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarLightM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"前雾灯:\t\t\t%@\n", self.frontfoglight.maa_value];
        [carInfoStr appendFormat:@"阅读灯:\t\t\t%@\n", self.readinglight.maa_value];
        [carInfoStr appendFormat:@"LED尾灯:\t\t\t%@\n", self.ledtaillight.maa_value];
        [carInfoStr appendFormat:@"日间行车灯:\t\t\t%@\n", self.daytimerunninglight.maa_value];
        [carInfoStr appendFormat:@"车内氛围灯:\t\t\t%@\n", self.interiorairlight.maa_value];
        [carInfoStr appendFormat:@"转向辅助灯:\t\t\t%@\n", self.lightsteeringassist.maa_value];
        [carInfoStr appendFormat:@"前大灯类型:\t\t\t%@\n", self.headlighttype.maa_value];
        [carInfoStr appendFormat:@"前大灯自动开闭:\t\t\t%@\n", self.headlightautomaticopen.maa_value];
        [carInfoStr appendFormat:@"前大灯延时关闭:\t\t\t%@\n", self.headlightdelayoff.maa_value];
        [carInfoStr appendFormat:@"前大灯随动装向:\t\t\t%@\n", self.headlightdynamicsteering.maa_value];
        [carInfoStr appendFormat:@"选配前大灯类型:\t\t\t%@\n", self.optionalheadlighttype.maa_value];
        [carInfoStr appendFormat:@"前大灯自动清洗功能:\t\t\t%@\n", self.headlightautomaticclean.maa_value];
        [carInfoStr appendFormat:@"会车前灯防眩目功能:\t\t\t%@\n", self.headlightdimming.maa_value];
        [carInfoStr appendFormat:@"前大灯照射范围调整:\t\t\t%@\n", self.headlightilluminationadjustment.maa_value];
    }
    else
    {
        if (self.frontfoglight.length > 0)
            [carInfoStr appendFormat:@"前雾灯:\t\t\t%@\n", self.frontfoglight];
        if (self.readinglight.length > 0)
            [carInfoStr appendFormat:@"阅读灯:\t\t\t%@\n", self.readinglight];
        if (self.ledtaillight.length > 0)
            [carInfoStr appendFormat:@"LED尾灯:\t\t\t%@\n", self.ledtaillight];
        if (self.daytimerunninglight.length > 0)
            [carInfoStr appendFormat:@"日间行车灯:\t\t\t%@\n", self.daytimerunninglight];
        if (self.interiorairlight.length > 0)
            [carInfoStr appendFormat:@"车内氛围灯:\t\t\t%@\n", self.interiorairlight];
        if (self.lightsteeringassist.length > 0)
            [carInfoStr appendFormat:@"转向辅助灯:\t\t\t%@\n", self.lightsteeringassist];
        if (self.headlighttype.length > 0)
            [carInfoStr appendFormat:@"前大灯类型:\t\t\t%@\n", self.headlighttype];
        if (self.headlightautomaticopen.length > 0)
            [carInfoStr appendFormat:@"前大灯自动开闭:\t\t\t%@\n", self.headlightautomaticopen];
        if (self.headlightdelayoff.length > 0)
            [carInfoStr appendFormat:@"前大灯延时关闭:\t\t\t%@\n", self.headlightdelayoff];
        if (self.headlightdynamicsteering.length > 0)
            [carInfoStr appendFormat:@"前大灯随动装向:\t\t\t%@\n", self.headlightdynamicsteering];
        if (self.optionalheadlighttype.length > 0)
            [carInfoStr appendFormat:@"选配前大灯类型:\t\t\t%@\n", self.optionalheadlighttype];
        if (self.headlightautomaticclean.length > 0)
            [carInfoStr appendFormat:@"前大灯自动清洗功能:\t\t\t%@\n", self.headlightautomaticclean];
        if (self.headlightdimming.length > 0)
            [carInfoStr appendFormat:@"会车前灯防眩目功能:\t\t\t%@\n", self.headlightdimming];
        if (self.headlightilluminationadjustment.length > 0)
            [carInfoStr appendFormat:@"前大灯照射范围调整:\t\t\t%@\n", self.headlightilluminationadjustment];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarInternalConfigM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"内饰颜色:\t\t\t%@\n", self.interiorcolor.maa_value];
        [carInfoStr appendFormat:@"后排环架:\t\t\t%@\n", self.rearcupholder.maa_value];
        [carInfoStr appendFormat:@"方向盘加热:\t\t\t%@\n", self.steeringwheelheating.maa_value];
        [carInfoStr appendFormat:@"多功能方向盘:\t\t\t%@\n", self.steeringwheelmultifunction.maa_value];
        [carInfoStr appendFormat:@"车内电源电压:\t\t\t%@\n", self.supplyvoltage.maa_value];
        [carInfoStr appendFormat:@"行车电脑显示屏:\t\t\t%@\n", self.computerscreen.maa_value];
        [carInfoStr appendFormat:@"方向盘调节方式:\t\t\t%@\n", self.steeringwheeladjustmentmode.maa_value];
        [carInfoStr appendFormat:@"方向盘前后调节:\t\t\t%@\n", self.steeringwheelbeforeadjustment.maa_value];
        [carInfoStr appendFormat:@"方向盘表面材料:\t\t\t%@\n", self.steeringwheelmaterial.maa_value];
        [carInfoStr appendFormat:@"方向盘记忆设置:\t\t\t%@\n", self.steeringwheelmemory.maa_value];
        [carInfoStr appendFormat:@"方向盘上下调节:\t\t\t%@\n", self.steeringwheelupadjustment.maa_value.maa_value];
        [carInfoStr appendFormat:@"HUD抬头数字显示:\t\t\t%@\n", self.huddisplay.maa_value];
    }
    else
    {
        if (self.interiorcolor.length > 0)
            [carInfoStr appendFormat:@"内饰颜色:\t\t\t%@\n", self.interiorcolor];
        if (self.rearcupholder.length > 0)
            [carInfoStr appendFormat:@"后排环架:\t\t\t%@\n", self.rearcupholder];
        if (self.steeringwheelheating.length > 0)
            [carInfoStr appendFormat:@"方向盘加热:\t\t\t%@\n", self.steeringwheelheating];
        if (self.steeringwheelmultifunction.length > 0)
            [carInfoStr appendFormat:@"多功能方向盘:\t\t\t%@\n", self.steeringwheelmultifunction];
        if (self.supplyvoltage.length > 0)
            [carInfoStr appendFormat:@"车内电源电压:\t\t\t%@\n", self.supplyvoltage];
        if (self.computerscreen.length > 0)
            [carInfoStr appendFormat:@"行车电脑显示屏:\t\t\t%@\n", self.computerscreen];
        if (self.steeringwheeladjustmentmode.length > 0)
            [carInfoStr appendFormat:@"方向盘调节方式:\t\t\t%@\n", self.steeringwheeladjustmentmode];
        if (self.steeringwheelbeforeadjustment.length > 0)
            [carInfoStr appendFormat:@"方向盘前后调节:\t\t\t%@\n", self.steeringwheelbeforeadjustment];
        if (self.steeringwheelmaterial.length > 0)
            [carInfoStr appendFormat:@"方向盘表面材料:\t\t\t%@\n", self.steeringwheelmaterial];
        if (self.steeringwheelmemory.length > 0)
            [carInfoStr appendFormat:@"方向盘记忆设置:\t\t\t%@\n", self.steeringwheelmemory];
        if (self.steeringwheelupadjustment.length > 0)
            [carInfoStr appendFormat:@"方向盘上下调节:\t\t\t%@\n", self.steeringwheelupadjustment];
        if (self.huddisplay.length > 0)
            [carInfoStr appendFormat:@"HUD抬头数字显示:\t\t\t%@\n", self.huddisplay];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarSeatM : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"座椅加热:\t\t\t%@\n", self.seatheating];
        [carInfoStr appendFormat:@"座椅材料:\t\t\t%@\n", self.seatmaterial];
        [carInfoStr appendFormat:@"座椅通风:\t\t\t%@\n", self.seatventilation];
        [carInfoStr appendFormat:@"运动座椅:\t\t\t%@\n", self.sportseat];
        [carInfoStr appendFormat:@"第三排座椅:\t\t\t%@\n", self.thirdrowseat];
        [carInfoStr appendFormat:@"电动座椅记忆:\t\t\t%@\n", self.electricseatmemory];
        [carInfoStr appendFormat:@"前座中央扶手:\t\t\t%@\n", self.frontseatcenterarmrest];
        [carInfoStr appendFormat:@"后座中央扶手:\t\t\t%@\n", self.rearseatcenterarmrest];
        [carInfoStr appendFormat:@"座椅高低调节:\t\t\t%@\n", self.seatheightadjustment];
        [carInfoStr appendFormat:@"座椅按摩功能:\t\t\t%@\n", self.seatmassage];
        [carInfoStr appendFormat:@"前座椅头枕调节:\t\t\t%@\n", self.frontseatheadrestadjustment];
        [carInfoStr appendFormat:@"后排座椅调节方式:\t\t\t%@\n", self.rearseatadjustmentmode];
        [carInfoStr appendFormat:@"后排座椅角度调节:\t\t\t%@\n", self.rearseatangleadjustment];
        [carInfoStr appendFormat:@"后排座位放倒比例:\t\t\t%@\n", self.rearseatreclineproportion];
        [carInfoStr appendFormat:@"副驾驶座椅调节方式:\t\t\t%@\n", self.auxiliaryseatadjustmentmode];
        [carInfoStr appendFormat:@"驾驶座座椅调节方式:\t\t\t%@\n", self.driverseatadjustmentmode];
        [carInfoStr appendFormat:@"驾驶座腰部支撑调节:\t\t\t%@\n", self.driverseatlumbarsupportadjustment];
        [carInfoStr appendFormat:@"驾驶座肩部支撑调节:\t\t\t%@\n", self.driverseatshouldersupportadjustment];
        [carInfoStr appendFormat:@"儿童安全座椅固定装置:\t\t\t%@\n", self.childseatfixdevice];
    }
    else
    {
        if (self.seatheating.length > 0)
            [carInfoStr appendFormat:@"座椅加热:\t\t\t%@\n", self.seatheating];
        if (self.seatmaterial.length > 0)
            [carInfoStr appendFormat:@"座椅材料:\t\t\t%@\n", self.seatmaterial];
        if (self.seatventilation.length > 0)
            [carInfoStr appendFormat:@"座椅通风:\t\t\t%@\n", self.seatventilation];
        if (self.sportseat.length > 0)
            [carInfoStr appendFormat:@"运动座椅:\t\t\t%@\n", self.sportseat];
        if (self.thirdrowseat.length > 0)
            [carInfoStr appendFormat:@"第三排座椅:\t\t\t%@\n", self.thirdrowseat];
        if (self.electricseatmemory.length > 0)
            [carInfoStr appendFormat:@"电动座椅记忆:\t\t\t%@\n", self.electricseatmemory];
        if (self.frontseatcenterarmrest.length > 0)
            [carInfoStr appendFormat:@"前座中央扶手:\t\t\t%@\n", self.frontseatcenterarmrest];
        if (self.rearseatcenterarmrest.length > 0)
            [carInfoStr appendFormat:@"后座中央扶手:\t\t\t%@\n", self.rearseatcenterarmrest];
        if (self.seatheightadjustment.length > 0)
            [carInfoStr appendFormat:@"座椅高低调节:\t\t\t%@\n", self.seatheightadjustment];
        if (self.seatmassage.length > 0)
            [carInfoStr appendFormat:@"座椅按摩功能:\t\t\t%@\n", self.seatmassage];
        if (self.frontseatheadrestadjustment.length > 0)
            [carInfoStr appendFormat:@"前座椅头枕调节:\t\t\t%@\n", self.frontseatheadrestadjustment];
        if (self.rearseatadjustmentmode.length > 0)
            [carInfoStr appendFormat:@"后排座椅调节方式:\t\t\t%@\n", self.rearseatadjustmentmode];
        if (self.rearseatangleadjustment.length > 0)
            [carInfoStr appendFormat:@"后排座椅角度调节:\t\t\t%@\n", self.rearseatangleadjustment];
        if (self.rearseatreclineproportion.length > 0)
            [carInfoStr appendFormat:@"后排座位放倒比例:\t\t\t%@\n", self.rearseatreclineproportion];
        if (self.auxiliaryseatadjustmentmode.length > 0)
            [carInfoStr appendFormat:@"副驾驶座椅调节方式:\t\t\t%@\n", self.auxiliaryseatadjustmentmode];
        if (self.driverseatadjustmentmode.length > 0)
            [carInfoStr appendFormat:@"驾驶座座椅调节方式:\t\t\t%@\n", self.driverseatadjustmentmode];
        if (self.driverseatlumbarsupportadjustment.length > 0)
            [carInfoStr appendFormat:@"驾驶座腰部支撑调节:\t\t\t%@\n", self.driverseatlumbarsupportadjustment];
        if (self.driverseatshouldersupportadjustment.length > 0)
            [carInfoStr appendFormat:@"驾驶座肩部支撑调节:\t\t\t%@\n", self.driverseatshouldersupportadjustment];
        if (self.childseatfixdevice.length > 0)
            [carInfoStr appendFormat:@"儿童安全座椅固定装置:\t\t\t%@\n", self.childseatfixdevice];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarEntcom : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"CD:\t\t\t%@\n", self.cd];
        [carInfoStr appendFormat:@"DVD:\t\t\t%@\n", self.dvd];
        [carInfoStr appendFormat:@"音响品牌:\t\t\t%@\n", self.audiobrand];
        [carInfoStr appendFormat:@"蓝牙系统:\t\t\t%@\n", self.bluetooth];
        [carInfoStr appendFormat:@"内置硬盘:\t\t\t%@\n", self.builtinharddisk];
        [carInfoStr appendFormat:@"车载电视:\t\t\t%@\n", self.cartv];
        [carInfoStr appendFormat:@"后排液晶屏:\t\t\t%@\n", self.rearlcdscreen];
        [carInfoStr appendFormat:@"扬声器数量:\t\t\t%@\n", self.speakernum];
        [carInfoStr appendFormat:@"中控台液晶屏:\t\t\t%@\n", self.consolelcdscreen];
        [carInfoStr appendFormat:@"外接音源接口:\t\t\t%@\n", self.externalaudiointerface];
        [carInfoStr appendFormat:@"定位互动服务:\t\t\t%@\n", self.locationservice];
    }
    else
    {
        if (self.cd.length > 0)
            [carInfoStr appendFormat:@"CD:\t\t\t%@\n", self.cd];
        if (self.dvd.length > 0)
            [carInfoStr appendFormat:@"DVD:\t\t\t%@\n", self.dvd];
        if (self.audiobrand.length > 0)
            [carInfoStr appendFormat:@"音响品牌:\t\t\t%@\n", self.audiobrand];
        if (self.bluetooth.length > 0)
            [carInfoStr appendFormat:@"蓝牙系统:\t\t\t%@\n", self.bluetooth];
        if (self.builtinharddisk.length > 0)
            [carInfoStr appendFormat:@"内置硬盘:\t\t\t%@\n", self.builtinharddisk];
        if (self.cartv.length > 0)
            [carInfoStr appendFormat:@"车载电视:\t\t\t%@\n", self.cartv];
        if (self.rearlcdscreen.length > 0)
            [carInfoStr appendFormat:@"后排液晶屏:\t\t\t%@\n", self.rearlcdscreen];
        if (self.speakernum.length > 0)
            [carInfoStr appendFormat:@"扬声器数量:\t\t\t%@\n", self.speakernum];
        if (self.consolelcdscreen.length > 0)
            [carInfoStr appendFormat:@"中控台液晶屏:\t\t\t%@\n", self.consolelcdscreen];
        if (self.externalaudiointerface.length > 0)
            [carInfoStr appendFormat:@"外接音源接口:\t\t\t%@\n", self.externalaudiointerface];
        if (self.locationservice.length > 0)
            [carInfoStr appendFormat:@"定位互动服务:\t\t\t%@\n", self.locationservice];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarAirCondrefrigerator : MARBaseDBModel

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll
{
    NSMutableString *carInfoStr = [NSMutableString string];
    if (isDisplayAll) {
        [carInfoStr appendFormat:@"车载冰箱:\t\t\t%@\n", self.carrefrigerator.maa_value];
        [carInfoStr appendFormat:@"后排出风口:\t\t\t%@\n", self.reardischargeoutlet.maa_value];
        [carInfoStr appendFormat:@"空调控制方式:\t\t\t%@\n", self.airconditioningcontrolmode.maa_value];
        [carInfoStr appendFormat:@"后排独立空调:\t\t\t%@\n", self.rearairconditioning.maa_value];
        [carInfoStr appendFormat:@"温度分区控制:\t\t\t%@\n", self.tempzonecontrol.maa_value];
        [carInfoStr appendFormat:@"车内空气净化装置:\t\t\t%@\n", self.airpurifyingdevice.maa_value];
        [carInfoStr appendFormat:@"空气调节/花粉过滤:\t\t\t%@\n", self.airconditioning.maa_value];
    }
    else
    {
        if (self.carrefrigerator.length > 0)
            [carInfoStr appendFormat:@"车载冰箱:\t\t\t%@\n", self.carrefrigerator];
        if (self.reardischargeoutlet.length > 0)
            [carInfoStr appendFormat:@"后排出风口:\t\t\t%@\n", self.reardischargeoutlet];
        if (self.airconditioningcontrolmode.length > 0)
            [carInfoStr appendFormat:@"空调控制方式:\t\t\t%@\n", self.airconditioningcontrolmode];
        if (self.rearairconditioning.length > 0)
            [carInfoStr appendFormat:@"后排独立空调:\t\t\t%@\n", self.rearairconditioning];
        if (self.tempzonecontrol.length > 0)
            [carInfoStr appendFormat:@"温度分区控制:\t\t\t%@\n", self.tempzonecontrol];
        if (self.airpurifyingdevice.length > 0)
            [carInfoStr appendFormat:@"车内空气净化装置:\t\t\t%@\n", self.airpurifyingdevice];
        if (self.airconditioning.length > 0)
            [carInfoStr appendFormat:@"空气调节/花粉过滤:\t\t\t%@\n", self.airconditioning];
    }
    if(carInfoStr.length > 0)
        [carInfoStr deleteCharactersInRange:NSMakeRange(carInfoStr.length - 1, 1)];
    else
        [carInfoStr appendString:@"-"];
    return carInfoStr;
}

@end

@implementation MAACarActualtest : MARBaseDBModel

+ (NSString *)getPrimaryKey
{
    return @"id";
}

@end

@implementation MAACarSimpleInfoM
+ (NSString *)getPrimaryKey
{
    return @"id";
}
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
