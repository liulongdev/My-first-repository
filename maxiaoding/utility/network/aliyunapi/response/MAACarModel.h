//
//  MAACarModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/1.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MAACarDefaultValue)
- (NSString *)maa_value;
@end

/**
 @link https://market.aliyun.com/products/57002002/cmapi011811.html?spm=5176.2020520132.101.28.mIy1pr#sku=yuncode581100000
 */
@interface MAACarSimpleInfoM : MARBaseDBModel

@property (nonatomic, strong) NSString *id;                 //!< ID
@property (nonatomic, strong) NSString *name;               //!< 名称
@property (nonatomic, strong) NSString *fullname;           //!< 全名
@property (nonatomic, strong) NSString *initial;            //!< 首字母
@property (nonatomic, strong) NSString *parentid;           //!< 上级ID
@property (nonatomic, strong) NSString *logo;               //!< LOGO
@property (nonatomic, strong) NSString *price;              //!< 官方指导价
@property (nonatomic, strong) NSString *yeartype;           //!< 年款
@property (nonatomic, strong) NSString *productionstate;    //!< 生产状态
@property (nonatomic, strong) NSString *salestate;          //!< 销售状态
@property (nonatomic, strong) NSString *sizetype;           //!< 尺寸类型
@property (nonatomic, strong) NSString *depth;              //!< 深度 1品牌 2子公司 3车型 4具体车型

@end

@class MAACarBasicInfoM;
@class MAACarBodyM;
@class MAACarEngineM;
@class MAACarGearboxM;
@class MAACarChassisBrake;
@class MAACarSafeM;
@class MAACarWheelM;
@class MAACarDrivingAuxiliaryM;
@class MAACarDoorMirrorM;
@class MAACarLightM;
@class MAACarInternalConfigM;
@class MAACarSeatM;
@class MAACarEntcom;
@class MAACarAirCondrefrigerator;
@class MAACarActualtest;

@interface MAACarModel : MAACarSimpleInfoM <MARModelDelegate>

@property (nonatomic, strong) MAACarBasicInfoM* basic;                          //!< 基本信息
@property (nonatomic, strong) MAACarBodyM *body;                                //!< 车体
@property (nonatomic, strong) MAACarEngineM *engine;                            //!< 发动机
@property (nonatomic, strong) MAACarGearboxM *gearbox;                          //!< 变速箱
@property (nonatomic, strong) MAACarChassisBrake *chassisbrake;                 //!< 底盘制动
@property (nonatomic, strong) MAACarSafeM *safe;                                //!< 安全配置
@property (nonatomic, strong) MAACarWheelM *wheel;                              //!< 车轮
@property (nonatomic, strong) MAACarDrivingAuxiliaryM *drivingauxiliary;        //!< 行车辅助
@property (nonatomic, strong) MAACarDoorMirrorM *doormirror;                    //!< 门窗/后视镜
@property (nonatomic, strong) MAACarLightM *light;                              //!< 灯光
@property (nonatomic, strong) MAACarInternalConfigM *internalconfig;            //!< 内部配置
@property (nonatomic, strong) MAACarSeatM *seat;                                //!< 后排座椅
@property (nonatomic, strong) MAACarEntcom *entcom;                             //!< 娱乐通讯
@property (nonatomic, strong) MAACarAirCondrefrigerator *aircondrefrigerator;   //!< 空调/冰箱
@property (nonatomic, strong) MAACarActualtest *actualtest;                     //!< 实际测试

+ (MAACarModel *)carModelWithCarId:(NSString *)carId;

@end

//!< 基本信息
@interface MAACarBasicInfoM : MARBaseDBModel

@property (nonatomic, strong) NSString *comfuelconsumption;                     //!< 综合工况油耗(L/100km)
@property (nonatomic, strong) NSString *displacement;                           //!< 排量(L)
@property (nonatomic, strong) NSString *gearbox;                                //!< 变速箱
@property (nonatomic, strong) NSString *maxspeed;                               //!< 最高车速(km/h)
@property (nonatomic, strong) NSString *officialaccelerationtime100;            //!< 官方0-100公里加速时间(S)
@property (nonatomic, strong) NSString *price;                                  //!< 厂家指导价
@property (nonatomic, strong) NSString *saleprice;                              //!< 商家报价
@property (nonatomic, strong) NSString *seatnum;                                //!< 乘员人数(区间)(个)
@property (nonatomic, strong) NSString *testaccelerationtime100;                //!< 实测0-100公里加速时间(S)
@property (nonatomic, strong) NSString *userfuelconsumption;                    //!< 网友油耗(L/100km)
@property (nonatomic, strong) NSString *vechiletax;                             //!< 车船税减免
@property (nonatomic, strong) NSString *warrantypolicy;                         //!< 保修政策

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 车体信息
@interface MAACarBodyM : MARBaseDBModel

@property (nonatomic, strong) NSString *approachangle;              //!< 接近角(º)
@property (nonatomic, strong) NSString *color;                      //!< 车身颜色
@property (nonatomic, strong) NSString *departureangle;             //!< 离去角(º)
@property (nonatomic, strong) NSString *doornum;                    //!< 车门数(个）
@property (nonatomic, strong) NSString *fronttrack;                 //!< 前轮距(mm)
@property (nonatomic, strong) NSString *fullweight;                 //!< 满载质量(kg)
@property (nonatomic, strong) NSString *height;                     //!< 车高(mm)
@property (nonatomic, strong) NSString *hoodtype;                   //!< 车棚型式
@property (nonatomic, strong) NSString *inductionluggage;           //!< 感应行李箱
@property (nonatomic, strong) NSString *len;                        //!< 车长(mm)
@property (nonatomic, strong) NSString *luggagemode;                //!< 行李箱盖开合方式
@property (nonatomic, strong) NSString *luggageopenmode;            //!< 行李箱打开方式
@property (nonatomic, strong) NSString *luggagevolume;              //!< 行李箱容积(L)
@property (nonatomic, strong) NSString *mingroundclearance;         //!< 最小离地间隙(mm)
@property (nonatomic, strong) NSString *reartrack;                  //!< 后轮距(mm)
@property (nonatomic, strong) NSString *roofluggagerack;            //!< 车顶行李箱架
@property (nonatomic, strong) NSString *sportpackage;               //!< 运动外观套件
@property (nonatomic, strong) NSString *tooftype;                   //!< 车顶型式
@property (nonatomic, strong) NSString *weight;                     //!< 整备质量(kg)
@property (nonatomic, strong) NSString *wheelbase;                  //!< 轴距(mm)
@property (nonatomic, strong) NSString *width;                      //!< 车宽(mm)

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 发动机信息
@interface MAACarEngineM : MARBaseDBModel
@property (nonatomic, strong) NSString *bore;                       //!< 缸径(mm)
@property (nonatomic, strong) NSString *compressionratio;           //!< 压缩比
@property (nonatomic, strong) NSString *cylinderarrangetype;        //!< 气缸排列型式
@property (nonatomic, strong) NSString *cylinderbodymaterial;       //!< 缸体材料
@property (nonatomic, strong) NSString *cylinderheadmaterial;       //!< 缸盖材料
@property (nonatomic, strong) NSString *cylindernum;                //!< 气缸数(个)
@property (nonatomic, strong) NSString *displacement;               //!< 排量(L)
@property (nonatomic, strong) NSString *displacementml;             //!< 排量(mL)
@property (nonatomic, strong) NSString *environmentalstandards;     //!< 环保标准
@property (nonatomic, strong) NSString *fuelgrade;                  //!< 燃油等级
@property (nonatomic, strong) NSString *fuelmethod;                 //!< 供油方式
@property (nonatomic, strong) NSString *fueltankcapacity;           //!< 燃油箱容积(L)
@property (nonatomic, strong) NSString *fueltype;                   //!< 燃油标号
@property (nonatomic, strong) NSString *intakeform;                 //!< 进气形式
@property (nonatomic, strong) NSString *maxhorsepower;              //!< 最大马力(Ps)
@property (nonatomic, strong) NSString *maxpower;                   //!< 最大功率(kW)
@property (nonatomic, strong) NSString *maxpowerspeed;              //!< 最大功率转速(rpm)
@property (nonatomic, strong) NSString *maxtorque;                  //!< 最大扭矩
@property (nonatomic, strong) NSString *maxtorquespeed;             //!< 最大扭速
@property (nonatomic, strong) NSString *model;                      //!< 发动机型号
@property (nonatomic, strong) NSString *position;                   //!< 发动机位置
@property (nonatomic, strong) NSString *startstopsystem;            //!< 启停系统
@property (nonatomic, strong) NSString *stroke;                     //!< 行程(mm)
@property (nonatomic, strong) NSString *valvestructure;             //!< 气门结构
@property (nonatomic, strong) NSString *valvetrain;                 //!< 每缸气门数(个)

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 变速箱信息
@interface MAACarGearboxM : MARBaseDBModel

@property (nonatomic, strong) NSString *gearbox;                    //!< 变速箱
@property (nonatomic, strong) NSString *shiftpaddles;               //!< 换挡拨片

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 底盘制动信息
@interface MAACarChassisBrake : MARBaseDBModel

@property (nonatomic, strong) NSString *adjustablesuspension;       //!< 可调悬挂
@property (nonatomic, strong) NSString *airsuspension;              //!< 空气悬挂
@property (nonatomic, strong) NSString *bodystructure;              //!< 车体结构
@property (nonatomic, strong) NSString *centerdifferentiallock;     //!< 中央差速器锁
@property (nonatomic, strong) NSString *drivemode;                  //!< 驱动方式
@property (nonatomic, strong) NSString *frontbraketype;             //!< 前制动类型
@property (nonatomic, strong) NSString *frontsuspensiontype;        //!< 前悬挂类型
@property (nonatomic, strong) NSString *parkingbraketype;           //!< 驻车制动类型
@property (nonatomic, strong) NSString *powersteering;              //!< 转向助力
@property (nonatomic, strong) NSString *rearbraketype;              //!< 后制动类型
@property (nonatomic, strong) NSString *rearsuspensiontype;         //!< 后悬挂类型

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 安全配置信息
@interface MAACarSafeM : MARBaseDBModel

@property (nonatomic, strong) NSString *airbagdrivingposition;      //!< 驾驶位安全气囊
@property (nonatomic, strong) NSString *airbagfronthead;            //!< 前排头部气囊(气帘)
@property (nonatomic, strong) NSString *airbagfrontpassenger;       //!< 副驾驶安全气囊
@property (nonatomic, strong) NSString *airbagfrontside;            //!< 前排侧安全气囊
@property (nonatomic, strong) NSString *airbagknee;                 //!< 膝部气囊
@property (nonatomic, strong) NSString *airbagrearhead;             //!< 后排头部气囊(气帘)
@property (nonatomic, strong) NSString *airbagrearside;             //!< 后排侧安全气囊
@property (nonatomic, strong) NSString *centrallocking;             //!< 中控门锁
@property (nonatomic, strong) NSString *childlock;                  //!< 儿童锁
@property (nonatomic, strong) NSString *engineantitheft;            //!< 发动机电子防盗
@property (nonatomic, strong) NSString *frontsafetybeltadjustment;  //!< 前安全带调节
@property (nonatomic, strong) NSString *keylessentry;               //!< 无钥匙进入系统
@property (nonatomic, strong) NSString *keylessstart;               //!< 无钥匙启动系统
@property (nonatomic, strong) NSString *rearsafetybelt;             //!< 后排安全带
@property (nonatomic, strong) NSString *remotekey;                  //!< 遥控钥匙
@property (nonatomic, strong) NSString *safetybeltlimiting;         //!< 安全带限力功能
@property (nonatomic, strong) NSString *safetybeltpretightening;    //!< 安全带预收紧功能
@property (nonatomic, strong) NSString *safetybeltprompt;           //!< 安全带未系提示
@property (nonatomic, strong) NSString *tirepressuremonitoring;     //!< 胎压监测装置
@property (nonatomic, strong) NSString *zeropressurecontinued;      //!< 零压续航(零胎压继续行驶)

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 车轮信息
@interface MAACarWheelM : MARBaseDBModel

@property (nonatomic, strong) NSString *fronttiresize;              //!< 前轮胎规格
@property (nonatomic, strong) NSString *hubmaterial;                //!< 轮毂材料
@property (nonatomic, strong) NSString *reartiresize;               //!< 后轮胎规格
@property (nonatomic, strong) NSString *sparetiretype;              //!< 备胎类型

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 行车辅助信息
@interface MAACarDrivingAuxiliaryM : MARBaseDBModel

@property (nonatomic, strong) NSString *abs;                        //!< 刹车防抱死(ABS)
@property (nonatomic, strong) NSString *activebraking;              //!< 自动刹车/主动安全系统
@property (nonatomic, strong) NSString *adaptivecruise;             //!< 自适应巡航
@property (nonatomic, strong) NSString *automaticparking;           //!< 自动驻车
@property (nonatomic, strong) NSString *automaticparkingintoplace;  //!< 自动泊车入位
@property (nonatomic, strong) NSString *blindspotdetection;         //!< 盲点检测
@property (nonatomic, strong) NSString *brakeassist;                //!< 刹车辅助(EBA/BAS/BA/EVA等)
@property (nonatomic, strong) NSString *cruisecontrol;              //!< 定速巡航
@property (nonatomic, strong) NSString *ebd;                        //!< 电子制动力分配系统(EBD)
@property (nonatomic, strong) NSString *eps;                        //!< 随速助力转向调节(EPS)
@property (nonatomic, strong) NSString *esp;                        //!< 动力稳定控制系统(EPS)
@property (nonatomic, strong) NSString *frontparkingradar;          //!< 泊车雷达(车前)
@property (nonatomic, strong) NSString *gps;                        //!< GPS导航系统
@property (nonatomic, strong) NSString *hilldescent;                //!< 陡坡缓降
@property (nonatomic, strong) NSString *hillstartassist;            //!< 上坡辅助
@property (nonatomic, strong) NSString *integralactivesteering;     //!< 整体主动转向系统
@property (nonatomic, strong) NSString *ldws;                       //!< 车道偏离预警系统
@property (nonatomic, strong) NSString *nightvisionsystem;          //!< 夜视系统
@property (nonatomic, strong) NSString *panoramiccamera;            //!< 全景摄像头
@property (nonatomic, strong) NSString *reverseimage;               //!< 倒车影像
@property (nonatomic, strong) NSString *reversingradar;             //!< 倒车雷达(车后)
@property (nonatomic, strong) NSString *tractioncontrol;            //!< 牵引力控制(ASR/TCS/TRC/ATC等)

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 门窗/后视镜信息
@interface MAACarDoorMirrorM : MARBaseDBModel

@property (nonatomic, strong) NSString *antipinchwindow;            //!< 电动窗防夹功能
@property (nonatomic, strong) NSString *electricpulldoor;           //!< 电动吸合门
@property (nonatomic, strong) NSString *electricwindow;             //!< 电动门窗
@property (nonatomic, strong) NSString *externalmirroradjustment;   //!< 外后视镜电动调节
@property (nonatomic, strong) NSString *externalmirrorfolding;      //!< 外后视镜电动折叠功能
@property (nonatomic, strong) NSString *externalmirrorheating;      //!< 外后视镜加热功能
@property (nonatomic, strong) NSString *externalmirrormemory;       //!< 外后视镜记忆功能
@property (nonatomic, strong) NSString *openstyle;                  //!< 开门方式
@property (nonatomic, strong) NSString *privacyglass;               //!< 隐私玻璃
@property (nonatomic, strong) NSString *rearmirrorwithturnlamp;     //!< 后视镜带侧转向灯
@property (nonatomic, strong) NSString *rearsidesunshade;           //!<
@property (nonatomic, strong) NSString *rearviewmirrorantiglare;    //!< 内后视镜防眩目功能
@property (nonatomic, strong) NSString *rearwindowsunshade;         //!< 后窗遮阳帘
@property (nonatomic, strong) NSString *rearwiper;                  //!< 后雨刷器
@property (nonatomic, strong) NSString *sensingwiper;               //!< 感应雨刷
@property (nonatomic, strong) NSString *skylightopeningmode;        //!< 天窗开喝模式
@property (nonatomic, strong) NSString *skylightstype;              //!< 天窗型式
@property (nonatomic, strong) NSString *sunvisormirror;             //!< 遮阳板化妆镜
@property (nonatomic, strong) NSString *uvinterceptingglass;        //!< 防紫外线/隔热玻璃

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 灯光信息
@interface MAACarLightM : MARBaseDBModel

@property (nonatomic, strong) NSString *daytimerunninglight;        //!< 日间行车灯
@property (nonatomic, strong) NSString *frontfoglight;              //!< 前雾灯
@property (nonatomic, strong) NSString *headlightautomaticclean;    //!< 前大灯自动清洗功能
@property (nonatomic, strong) NSString *headlightautomaticopen;     //!< 前大灯自动开闭
@property (nonatomic, strong) NSString *headlightdelayoff;          //!< 前大灯延时关闭
@property (nonatomic, strong) NSString *headlightdimming;           //!< 会车前灯防眩目功能
@property (nonatomic, strong) NSString *headlightdynamicsteering;   //!< 前大灯随动装向
@property (nonatomic, strong) NSString *headlightilluminationadjustment;    //!< 前大灯照射范围调整
@property (nonatomic, strong) NSString *headlighttype;              //!< 前大灯类型
@property (nonatomic, strong) NSString *interiorairlight;           //!< 车内氛围灯
@property (nonatomic, strong) NSString *ledtaillight;               //!< LED尾灯
@property (nonatomic, strong) NSString *lightsteeringassist;        //!< 转向辅助灯
@property (nonatomic, strong) NSString *optionalheadlighttype;      //!< 选配前大灯类型
@property (nonatomic, strong) NSString *readinglight;               //!< 阅读灯

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 内部配置
@interface MAACarInternalConfigM : MARBaseDBModel

@property (nonatomic, strong) NSString *computerscreen;             //!< 行车电脑显示屏
@property (nonatomic, strong) NSString *huddisplay;                 //!< HUD抬头数字显示
@property (nonatomic, strong) NSString *interiorcolor;              //!< 内饰颜色
@property (nonatomic, strong) NSString *rearcupholder;              //!< 后排环架
@property (nonatomic, strong) NSString *steeringwheeladjustmentmode;//!< 方向盘调节方式
@property (nonatomic, strong) NSString *steeringwheelbeforeadjustment;  //!< 方向盘前后调节
@property (nonatomic, strong) NSString *steeringwheelheating;           //!< 方向盘加热
@property (nonatomic, strong) NSString *steeringwheelmaterial;          //!< 方向盘表面材料
@property (nonatomic, strong) NSString *steeringwheelmemory;            //!< 方向盘记忆设置
@property (nonatomic, strong) NSString *steeringwheelmultifunction;     //!< 多功能方向盘
@property (nonatomic, strong) NSString *steeringwheelupadjustment;      //!< 方向盘上下调节
@property (nonatomic, strong) NSString *supplyvoltage;                  //!< 车内电源电压

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 后排座椅信息
@interface MAACarSeatM : MARBaseDBModel

@property (nonatomic, strong) NSString *auxiliaryseatadjustmentmode;    //!< 副驾驶座椅调节方式
@property (nonatomic, strong) NSString *childseatfixdevice;             //!< 儿童安全座椅固定装置
@property (nonatomic, strong) NSString *driverseatadjustmentmode;       //!< 驾驶座座椅调节方式
@property (nonatomic, strong) NSString *driverseatlumbarsupportadjustment;  //!< 驾驶座腰部支撑调节
@property (nonatomic, strong) NSString *driverseatshouldersupportadjustment;//!< 驾驶座肩部支撑调节
@property (nonatomic, strong) NSString *electricseatmemory;                 //!< 电动座椅记忆
@property (nonatomic, strong) NSString *frontseatcenterarmrest;             //!< 前座中央扶手
@property (nonatomic, strong) NSString *frontseatheadrestadjustment;        //!< 前座椅头枕调节
@property (nonatomic, strong) NSString *rearseatadjustmentmode;             //!< 后排座椅调节方式
@property (nonatomic, strong) NSString *rearseatangleadjustment;            //!< 后排座椅角度调节
@property (nonatomic, strong) NSString *rearseatcenterarmrest;              //!< 后座中央扶手
@property (nonatomic, strong) NSString *rearseatreclineproportion;          //!< 后排座位放倒比例
@property (nonatomic, strong) NSString *seatheating;                        //!< 座椅加热
@property (nonatomic, strong) NSString *seatheightadjustment;               //!< 座椅高低调节
@property (nonatomic, strong) NSString *seatmassage;                        //!< 座椅按摩功能
@property (nonatomic, strong) NSString *seatmaterial;                       //!< 座椅材料
@property (nonatomic, strong) NSString *seatventilation;                    //!< 座椅通风
@property (nonatomic, strong) NSString *sportseat;                          //!< 运动座椅
@property (nonatomic, strong) NSString *thirdrowseat;                       //!< 第三排座椅

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 娱乐通讯信息
@interface MAACarEntcom : MARBaseDBModel

@property (nonatomic, strong) NSString *audiobrand;             //!< 音响品牌
@property (nonatomic, strong) NSString *bluetooth;              //!< 蓝牙系统
@property (nonatomic, strong) NSString *builtinharddisk;        //!< 内置硬盘
@property (nonatomic, strong) NSString *cartv;                  //!< 车载电视
@property (nonatomic, strong) NSString *cd;                     //!< CD
@property (nonatomic, strong) NSString *consolelcdscreen;       //!< 中控台液晶屏
@property (nonatomic, strong) NSString *dvd;                    //!< DVD
@property (nonatomic, strong) NSString *externalaudiointerface; //!< 外接音源接口
@property (nonatomic, strong) NSString *locationservice;        //!< 定位互动服务
@property (nonatomic, strong) NSString *rearlcdscreen;          //!< 后排液晶屏
@property (nonatomic, strong) NSString *speakernum;             //!< 扬声器数量

//- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end


//!< //!< 空调/冰箱信息
@interface MAACarAirCondrefrigerator : MARBaseDBModel

@property (nonatomic, strong) NSString *airconditioning;            //!< 空气调节/花粉过滤
@property (nonatomic, strong) NSString *airconditioningcontrolmode; //!< 空调控制方式
@property (nonatomic, strong) NSString *airpurifyingdevice;         //!< 车内空气净化装置
@property (nonatomic, strong) NSString *carrefrigerator;            //!< 车载冰箱
@property (nonatomic, strong) NSString *rearairconditioning;        //!< 后排独立空调
@property (nonatomic, strong) NSString *reardischargeoutlet;        //!< 后排出风口
@property (nonatomic, strong) NSString *tempzonecontrol;            //!< 温度分区控制

- (NSString *)carInfoDescDispalyAll:(BOOL)isDisplayAll;

@end

//!< 实际测试信息
@interface MAACarActualtest : MARBaseDBModel

@property (nonatomic, strong) NSString *accelerationtime100;        //!< 加速时间(0-100km/h)(s)
@property (nonatomic, strong) NSString *brakingdistance;            //!< 制动距离(0-100km/h)(m)

@end

// ---------------------------------------------------------
// ---------------------------------------------------------

@interface MAACarBrandM : MARBaseDBModel

@property (nonatomic, strong) NSString *id;                     //!< ID
@property (nonatomic, strong) NSString *name;                   //!< 名称
@property (nonatomic, strong) NSString *initial;                //!< 首字母
@property (nonatomic, strong) NSString *parentid;               //!< 上级ID
@property (nonatomic, strong) NSString *logo;                   //!< LOGO
@property (nonatomic, strong) NSString *depth;                  //!< 深度 1品牌 2子公司 3车型 4具体车型
@end

@class MAACarTypeM;
@interface MAACarFactoryM : MAACarBrandM <MARModelDelegate>
@property (nonatomic, strong) NSArray<MAACarTypeM *> *carlist;  //!< 车型集合

+ (NSArray<MAACarFactoryM *> *)carFactoryArrayWithBrandId:(NSString *)brandId;

@end

// 车型
@interface MAACarTypeM : MAACarBrandM <MARModelDelegate>

@property (nonatomic, strong) NSString *fullname;                   //!< 全名
@property (nonatomic, strong) NSString *salestate;                  //!< 销售状态
@property (nonatomic, strong) NSArray<MAACarSimpleInfoM *> *list;   //!< 具体车型简单介绍

@end

