//
//  MARMobMenuVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobMenuVC.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "MARBaseRequest.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MARUserNetworkManager.h"
#import "MARWYNewNetworkManager.h"
#import "MARWYNewViewController.h"
#import "MARWYVideoNewVC.h"
#import "MAACarBrandListVC.h"
#import "MARCitiesWeatherVC.h"
#import "MAROpencvCameraVC.h"

static NSString * const mobTitle_wxArticle          = @"微信热门";
static NSString * const mobTitle_historyToday       = @"历史上的今天";
static NSString * const mobTitle_phoneNumberSetting = @"手机设置";
static NSString * const mobTitle_utilityTool        = @"实用工具";
static NSString * const mobTitle_carBrand           = @"汽车";
static NSString * const mobTitle_cookMenu           = @"菜谱";
static NSString * const mineCellTitle_login         = @"登录模块";
static NSString * const mineCellTitle_mine          = @"我的";
static NSString * const mineCellTitle_setting       = @"设置";
static NSString * const aliFeedback_feedback        = @"我要反馈";

static NSString * const mobTitle_testFunction       = @"测试";
static NSString * const mobTitle_tianxingData       = @"天行数据";
static NSString * const mobTitle_wangyi             = @"网易";
static NSString * const mobTitle_wangyiVideo        = @"网易视频";

static NSString * const cellTitle_weather           = @"天气";
static NSString * const cellTitle_car               = @"汽车（新）";
static NSString * const cellTitle_baiduVoice        = @"百度语音";

static NSString * const cellTitle_faceRecognition        = @"头像识别";

static NSString * const cellTitle_opencvTest        = @"opencv test";

static NSString * const cellTitle_gpuLvjingTest        = @"CPU lvjing";

static NSString * const cellTitle_appstoreComment       = @"应用评分";

@interface MARMobMenuVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@property (nonatomic, strong) YWFeedbackViewController *feedbackVC;
@end

@implementation MARMobMenuVC
{
    NSInteger unReadFeedbackNumber;
}
- (void)viewDidLoad {
    self.title = @"马小丁";
    [super viewDidLoad];
    
//    [self getAliFeedbackVC];
//    [self getAliFeedbackUnreadCount];
    
    // Do any additional setup after loading the view.
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[mobTitle_wxArticle,
                        mobTitle_historyToday,
//                        mobTitle_phoneNumberSetting,
//                        mobTitle_utilityTool,
                        mobTitle_carBrand,
                        mobTitle_cookMenu,
                        mobTitle_tianxingData,
                        mobTitle_testFunction,
                        mineCellTitle_setting,
                        mineCellTitle_mine,
                        mineCellTitle_login,
                        mobTitle_wangyi,
                        mobTitle_wangyiVideo,
                        cellTitle_weather,
                        cellTitle_car,
                        cellTitle_baiduVoice,
                        cellTitle_faceRecognition,
                        cellTitle_opencvTest,
                        cellTitle_gpuLvjingTest,
                        cellTitle_appstoreComment,
//                        aliFeedback_feedback,
                        ];
    }
    return _titleArray;
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:AliFeedbackAppKey appSecret:AliFeedbackSecretKey];
    }
    return _feedbackKit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.titleArray.count > row) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = self.titleArray[row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    if ([mobTitle_wxArticle isEqualToString:label.text]) {
        [self performSegueWithIdentifier:@"goArticleCategoryVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_wxArticle"];
    }
    else if ([mobTitle_historyToday isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goHistoryDayVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_historyDay"];
    }
    else if ([mobTitle_phoneNumberSetting isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goPhoneNumberSettingVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_phoneNumbeSetting"];
    }
    else if ([mobTitle_utilityTool isEqualToString:label.text])
    {
        
    }
    else if ([mobTitle_carBrand isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goCarBrandListVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_carBrand"];
    }
    else if ([mobTitle_cookMenu isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goCookCategoryCollectionVC" sender:nil];
//        [self performSegueWithIdentifier:@"goCookCategoryListVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_cookCategoryList"];
    }
    else if ([mobTitle_testFunction isEqualToString:label.text])
    {
        [MARMobUtil test];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_test"];
        return;
        [MARWYNewNetworkManager getNewTitleListSuccess:^(NSArray<MARWYNewCategoryTitleModel *> *categoryTitleArray) {
            NSLog(@">>>>>> titleArray : %@", categoryTitleArray);
        } failure:^(NSURLSessionTask *task, NSError *error) {
            NSLog(@">>>>>> get WY titles error : %@", error);
        }];
//        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Login storyboardId:kSBID_Login_LoginViewController];
//        [self mar_pushViewController:vc animated:YES];
        
        return;
        
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                MARThirdPlatFormLoginR *thirdPlatFromLoginR = [MARThirdPlatFormLoginR new];
                [thirdPlatFromLoginR mar_modelSetWithJSON:[resp mar_modelToJSONObject]];
                
                [MARUserNetworkManager thirdPlatformLogin:thirdPlatFromLoginR success:^(NSURLSessionTask *task, id responseObject) {
                    NSLog(@">>>>>> third login success : %@", responseObject);
                } failure:^(NSURLSessionTask *task, NSError *error) {
                    NSLog(@">>>>> third login failure: %@", error);
                }];
                
                // 授权信息
                NSLog(@"QQ uid: %@", resp.uid);
                NSLog(@"QQ openid: %@", resp.openid);
                NSLog(@"QQ unionid: %@", resp.unionId);
                NSLog(@"QQ accessToken: %@", resp.accessToken);
                NSLog(@"QQ expiration: %@", resp.expiration);
                NSLog(@"QQ usid: %@", resp.usid);
                
                // 用户信息
                NSLog(@"QQ name: %@", resp.name);
                NSLog(@"QQ iconurl: %@", resp.iconurl);
                NSLog(@"QQ gender: %@", resp.unionGender);
                
                // 第三方平台SDK源数据
                NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            }
        }];
        return;
    }
    else if ([aliFeedback_feedback isEqualToString:label.text])
    {
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_aliFeedback"];
        self.feedbackVC.fd_interactivePopDisabled = YES;
        [self mar_pushViewController:self.feedbackVC animated:YES];
    }
    else if ([mineCellTitle_setting isEqualToString:label.text])
    {
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_setting"];
        [self performSegueWithIdentifier:@"goSettingVC" sender:nil];
    }
    else if ([mineCellTitle_mine isEqualToString:label.text])
    {
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_mine"];
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Mine storyboardId:kSBID_Mine_MineVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([mobTitle_tianxingData isEqualToString:label.text])
    {
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_tianxingData"];
        [self performSegueWithIdentifier:@"goTianxingMenuVC" sender:nil];
    }
    else if ([mobTitle_wangyi isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Wangyi storyboardId:kSBID_Wangyi_WYNewViewController];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([mobTitle_wangyiVideo isEqualToString:label.text])
    {
        UIViewController *vc = [MARWYVideoNewVC new];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([mineCellTitle_login isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Login storyboardId:kSBID_Login_LoginViewController];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_weather isEqualToString:label.text])
    {
        MARCitiesWeatherVC *citisWeatherVC = [[MARCitiesWeatherVC alloc] init];
        [self mar_pushViewController:citisWeatherVC animated:YES];
        return;
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Weather storyboardId:kSBID_Weather_WeatherVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_car isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Car storyboardId:kSBID_Car_CarBrandListVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_baiduVoice isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_VoiceAudio storyboardId:kSBID_VoiceAudio_VoiceAudioTestVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_faceRecognition isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_FaceRecognition storyboardId:kSBID_FaceRecognition_FaceRecognitionVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_opencvTest isEqualToString:label.text])
    {
//        MAROpencvCameraVC *vc = [[MAROpencvCameraVC alloc] init];
//        [self mar_pushViewController:vc animated:YES];
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Opencv storyboardId:kSBID_OpencvDemo_OpencvTestVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_gpuLvjingTest isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_GpuImage storyboardId:kSBID_GpuImage_GpuImageCameraVC];
        [self mar_pushViewController:vc animated:YES];
    }
    else if ([cellTitle_appstoreComment isEqualToString:label.text])
    {
        UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_LitDemo storyboardId:kSBID_LitDemo_AppstoreCommentVC];
        [self mar_pushViewController:vc animated:YES];
    }
    
}

- (void)getAliFeedbackVC
{
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            weakSelf.feedbackVC = viewController;
            weakSelf.feedbackVC.closeBlock = ^(BCFeedbackViewController *feedbackController) {
                [feedbackController.navigationController popViewControllerAnimated:YES];
                NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:RGBHEX(APPNaviTint), NSForegroundColorAttributeName, [UIFont systemFontOfSize:kSCALE(15.f)], NSFontAttributeName, nil];
                [weakSelf.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
            };
            _titleArray = @[mobTitle_wxArticle,
                            mobTitle_historyToday,
                            //                        mobTitle_phoneNumberSetting,
                            //                        mobTitle_utilityTool,
                            mobTitle_carBrand,
                            mobTitle_cookMenu,
                            mobTitle_tianxingData,
                            mobTitle_testFunction,
                            mineCellTitle_setting,
                            mineCellTitle_mine,
                            mineCellTitle_login,
                            mobTitle_wangyi,
                            mobTitle_wangyiVideo,
                            cellTitle_weather,
                            cellTitle_car,
                            cellTitle_baiduVoice,
                            cellTitle_faceRecognition,
                            cellTitle_opencvTest,
                            cellTitle_gpuLvjingTest,
                            cellTitle_appstoreComment,
                            aliFeedback_feedback,
                            ];
            [weakSelf.tableView reloadData];
            
            //                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            //                [weakSelf presentViewController:nav animated:YES completion:nil];
            //
            //                [viewController setCloseBlock:^(UIViewController *aParentController){
            //                    [aParentController dismissViewControllerAnimated:YES completion:nil];
            //                }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            
        }
    }];
}


/**
 获取阿里用户反馈未读数量
 */
- (void)getAliFeedbackUnreadCount
{
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        if (error == nil) {
            strongSelf->unReadFeedbackNumber = unreadCount;
            [strongSelf.tableView reloadData];
            if (unReadFeedbackNumber > 0) {
                NSString *infoMsg = [NSString stringWithFormat:@"您有%ld反馈回复未读", (long)unReadFeedbackNumber];
                ShowInfoMessage(infoMsg, 1.f);
            }
        } else {
            NSString *errMsg = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            NSLog(@">>>> getAliFeedbackUnreadCount error : %@", errMsg);
        }
    }];
}

@end
