//
//  MARLoginViewController.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/31.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARLoginViewController.h"
#import "MARUserNetworkManager.h"
#import "MARPhoneOperationVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface MARThirdLoginModel : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) UMSocialPlatformType platformType;
- (instancetype)initWithPlatformType:(UMSocialPlatformType)type imageName:(NSString *)imageName;
@end

@interface MARThirdLoginCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MARThirdLoginCollectionCell
@end

@implementation MARThirdLoginModel
- (instancetype)initWithPlatformType:(UMSocialPlatformType)type imageName:(NSString *)imageName
{
    self = [super init];
    if (!self) return nil;
    _platformType = type;
    _imageName = imageName;
    return self;
}
@end

@interface MARLoginViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (strong, nonatomic) IBOutlet UIView *underLineView;
@property (strong, nonatomic) IBOutlet UIButton *passwordLoginViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *quickLoginViewBtn;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *passwordLoginBtn;

@property (strong, nonatomic) IBOutlet UITextField *phoneQuickTF;
@property (strong, nonatomic) IBOutlet UIButton *quickLoginBtn;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_underLineCenterX;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


- (IBAction)clickPasswordViewBtnAction:(id)sender;
- (IBAction)clickQuickLoginViewBtnAction:(id)sender;

- (IBAction)clickPasswordBtnAction:(id)sender;
- (IBAction)clickQuickBtnAcion:(id)sender;

#pragma mark - custom property
@property (nonatomic, strong) NSMutableArray * thirdLoginArray;

@end

@implementation MARLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.underLineView.hidden = YES;
    if (self.presentingViewController) {
        self.fd_prefersNavigationBarHidden = YES;
    }
    self.isTapResignTFS = YES;
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.scrollView, self);
    self.loginScrollView.delegate = self;
    self.loginScrollView.pagingEnabled = YES;
    self.loginScrollView.bounces = NO;
    self.loginScrollView.showsHorizontalScrollIndicator = NO;
    self.loginScrollView.scrollEnabled = NO;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.underLineView.hidden = NO;
    CGFloat firstCenterX = self.passwordLoginViewBtn.mar_centerX;
    CGFloat underLineActivieLength = self.quickLoginViewBtn.mar_centerX - firstCenterX;
    CGFloat contentOffsetX = self.loginScrollView.contentOffset.x;
    self.constraint_underLineCenterX.constant = firstCenterX + underLineActivieLength * (contentOffsetX / self.loginScrollView.mar_width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)thirdLoginArray
{
    if (!_thirdLoginArray) {
        _thirdLoginArray = [NSMutableArray arrayWithCapacity:3];
        if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
            [_thirdLoginArray addObject:[[MARThirdLoginModel alloc] initWithPlatformType:UMSocialPlatformType_QQ imageName:@"appicon_qq"]];
        }
        if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
            [_thirdLoginArray addObject:[[MARThirdLoginModel alloc] initWithPlatformType:UMSocialPlatformType_WechatSession imageName:@"appicon_wechat"]];
        }
        if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Sina]) {
            [_thirdLoginArray addObject:[[MARThirdLoginModel alloc] initWithPlatformType:UMSocialPlatformType_Sina imageName:@"appicon_sina"]];
        }
    }
    return _thirdLoginArray;
    
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.loginScrollView == scrollView) {
        CGFloat firstCenterX = self.passwordLoginViewBtn.mar_centerX;
        CGFloat underLineActivieLength = self.quickLoginViewBtn.mar_centerX - firstCenterX;
        CGFloat contentOffsetX = self.loginScrollView.contentOffset.x;
        self.constraint_underLineCenterX.constant = firstCenterX + underLineActivieLength * (contentOffsetX / self.loginScrollView.mar_width);
    }
}

- (IBAction)clickPasswordViewBtnAction:(id)sender {
    [self.loginScrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)clickQuickLoginViewBtnAction:(id)sender {
    [self.loginScrollView setContentOffset:CGPointMake(self.loginScrollView.mar_width, 0) animated:YES];
}

- (IBAction)clickPasswordBtnAction:(id)sender {
    if (![self.phoneTF.text mar_isMobileNumber]) {
        ShowInfoMessage(@"请输入正确的手机号", 1.f);
        return;
    }
    if ([self.passwordTF.text mar_stringByTrim].length <= 0) {
        ShowInfoMessage(@"请输入密码", 1.f);
        return;
    }
    NSString *phone = self.phoneTF.text;
    NSString *password = [self.passwordTF.text mar_hmacSHA256StringWithKey:MARCRYPTOHMACSHA256KEY];
    
    MARLoginWithPhoneR *loginWithPhoneR = [MARLoginWithPhoneR new];
    loginWithPhoneR.phone = phone;
    loginWithPhoneR.password = password;
    @weakify(self)
    [MARUserNetworkManager loginWithPhone:loginWithPhoneR success:^(NSURLSessionTask *task, id responseObject) {
        MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
        @strongify(self)
        if (response.isSuccess) {
            ShowSuccessMessage(@"登录成功", 1.f);
            MARUserInfoModel *userInfo = [MARUserInfoModel mar_modelWithJSON:response.body];
            MARGLOBALMODEL.userInfo = userInfo;
            UIViewController *settingVC = [UIViewController vcWithStoryboardName:kSBNAME_Mine storyboardId:kSBID_Mine_MineVC];
            [strong_self mar_pushViewController:settingVC animated:YES];
        }
        else
        {
            ShowErrorMessage(@"账号或者密码错误", 1.5f);
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        ShowErrorMessage(@"登录失败", 1.5f);
        MARLog(@"登录失败： %@", error);
    }];
    
}

- (IBAction)clickQuickBtnAcion:(id)sender {
    if (![self.phoneQuickTF.text mar_isMobileNumber]) {
        ShowInfoMessage(@"请输入正确的手机号", 1.f);
        return;
    }
    
    UIViewController *vc = [UIViewController vcWithStoryboardName:kSBNAME_Login storyboardId:kSBID_Login_PhoneOperationVC];
    if ([vc isKindOfClass:[MARPhoneOperationVC class]]) {
        MARPhoneOperationVC *phoneOperationVC = (MARPhoneOperationVC *)vc;
        phoneOperationVC.phoneNumber = self.phoneQuickTF.text;
        phoneOperationVC.operationType = MARPhoneOperationTypeQuickLogin;
        [self mar_pushViewController:phoneOperationVC animated:YES];
    }
    
//    MARQuickLoginWithPhoneR *quickLoginWithPhoneR = [MARQuickLoginWithPhoneR new];
//    quickLoginWithPhoneR.phone = self.phoneQuickTF.text;
//    [MARUserNetworkManager quickLoginWithPhone:quickLoginWithPhoneR success:^(NSURLSessionTask *task, id responseObject) {
//        MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
//        if ([response isSuccess]) {
//            MARUserInfoModel *userInfo = [MARUserInfoModel mar_modelWithJSON:response.body];
//            MARGLOBALMODEL.userInfo = userInfo;
//            NSLog(@"quick login success");
//
//            UIViewController *settingVC = [UIViewController vcWithStoryboardName:kSBNAME_Mine storyboardId:kSBID_Mine_MineVC];
//            [self mar_pushViewController:settingVC animated:YES];
//
//        }
//        else
//            NSLog(@"quick login error");
//
//
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        NSLog(@"quick login error : %@", error);
//    }];
}

#pragma mark - UICollection Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.thirdLoginArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARThirdLoginCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    if (self.thirdLoginArray.count > indexPath.row) {
        MARThirdLoginModel *model = self.thirdLoginArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:model.imageName];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARLog(@"》》》》》》》》》》》》>>>>>>>>>>> ");
    if (self.thirdLoginArray.count > indexPath.row) {
        MARThirdLoginModel *model = self.thirdLoginArray[indexPath.row];
        @weakify(self)
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:model.platformType currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                ShowErrorMessage(@"登录失败", 1.5f);
                MARLog(@"第三方登录失败 error : %@", error);
            } else {
                UMSocialUserInfoResponse *resp = result;
                
                MARThirdPlatFormLoginR *thirdPlatFromLoginR = [MARThirdPlatFormLoginR new];
                [thirdPlatFromLoginR mar_modelSetWithJSON:[resp mar_modelToJSONObject]];
                
                [MARUserNetworkManager thirdPlatformLogin:thirdPlatFromLoginR success:^(NSURLSessionTask *task, id responseObject) {
                    @strongify(self)
                    if (!strong_self) return;
                    MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
                    if (response.isSuccess) {
                        ShowSuccessMessage(@"登录成功", 1.f);
                        MARUserInfoModel *userInfo = [MARUserInfoModel mar_modelWithJSON:response.body];
                        MARGLOBALMODEL.userInfo = userInfo;
                        UIViewController *settingVC = [UIViewController vcWithStoryboardName:kSBNAME_Mine storyboardId:kSBID_Mine_MineVC];
                        [strong_self mar_pushViewController:settingVC animated:YES];
                    }
                    else
                    {
                        ShowErrorMessage(@"登录失败! 请稍后再试", 1.5);
                    }
                    NSLog(@">>>>>> third login success : %@", responseObject);
                } failure:^(NSURLSessionTask *task, NSError *error) {
                    NSLog(@">>>>> third login failure: %@", error);
                }];
                
                // 第三方平台SDK源数据
                NSLog(@"data of third login: %@", [resp mar_modelDescription]);
            }
        }];
        
    }
}

@end
