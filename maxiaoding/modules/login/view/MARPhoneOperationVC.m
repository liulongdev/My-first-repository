//
//  MARPhoneOperationVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARPhoneOperationVC.h"
#import "MARUserNetworkManager.h"
#import "MARSMS.h"
#import "MARUserNetworkManager.h"

@interface MARPhoneOperationVC ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *operationBtn;

- (IBAction)clickGetCodeBtnAction:(id)sender;
- (IBAction)clickOperationBtnAction:(id)sender;

@end

@implementation MARPhoneOperationVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)UIGlobal
{
    self.phoneTF.text = self.phoneNumber;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSTimer *timer = nil;
    switch (self.operationType) {
        case MARPhoneOperationTypeQuickLogin:
            timer = MARUTILITY.quickLoginPhoneCodeTimer;
            break;
        case MARPhoneOperationTypeBind:
            timer = MARUTILITY.bindPhoneCodeTimer;
            break;
        case MARPhoneOperationTypeSetPassword:
            timer = MARUTILITY.setPasswordPhoneCodeTimer;
            break;
    }
    
    BOOL needReset = NO;
    if (timer) {
        if ([timer isValid]) {
            NSDictionary *userInfo = MARUTILITY.quickLoginPhoneCodeTimer.userInfo;
            NSInteger count = [userInfo[@"count"] integerValue];
            if (count <= 0) {
                [timer invalidate];
                timer = nil;
                needReset = YES;
            }
            else
            {
                self.getCodeBtn.enabled = NO;
                [self.getCodeBtn setTitle:MARSTRWITHINT(count) forState:UIControlStateDisabled];
            }
            
        }
        else
        {
            needReset = YES;
        }
    }
    if (needReset) {
        self.getCodeBtn.enabled = YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)clickGetCodeBtnAction:(id)sender {
    NSString *phone = self.phoneTF.text;
    if (![phone mar_isMobileNumber]) {
        ShowInfoMessage(@"您输入的手机号错误，或者暂不支持该手机号", 1.f);
        return;
    }
    @weakify(self)
    self.phoneNumber = phone;
    [MARSMS getPhoneCodeWithPhone:phone result:^(NSError *err) {
        @strongify(self)
        if (!strong_self) return;
        if (err) {
            ShowErrorMessage(@"发送验证码失败!", 1.5f);
        }
        else
        {
            ShowSuccessMessage(@"发送成功!", 1.f);
            [strong_self beginTimeSchedule];
        }
    }];
}

- (void)beginTimeSchedule
{
    [MARUTILITY setPhoneCodeTimerWithType:self.operationType phone:self.phoneNumber];
}

- (IBAction)clickOperationBtnAction:(id)sender {
    
    NSString *phone = self.phoneTF.text;
    NSString *code = self.codeTF.text;
    if (![phone mar_isMobileNumber]) {
        ShowInfoMessage(@"您输入的手机号错误，或者暂不支持该手机号", 1.f);
        return;
    }
    if ([code mar_stringByTrim].length == 0) {
        ShowInfoMessage(@"请输入验证码", 1.f);
    }
    self.phoneNumber = phone;
    @weakify(self)
    [MARSMS checkVerifyCode:code phoneNumber:phone result:^(NSError *err) {
        @strongify(self)
        if (!strong_self) return;
        if (err) {
            ShowErrorMessage([err localizedDescription] ?: @"验证失败", 1.5f);
        }
        else
        {
            [strong_self operationAction];
        }
    }];
}

- (void)operationAction
{
    switch (self.operationType) {
        case MARPhoneOperationTypeQuickLogin:
            [self quickLoginAction];
            break;
        case MARPhoneOperationTypeBind:
        {}
            break;
        case MARPhoneOperationTypeSetPassword:
        {
            [self performSegueWithIdentifier:@"goSetPasswrodVC" sender:nil];
        }
            break;
    }
}

- (void)quickLoginAction
{
    MARQuickLoginWithPhoneR *quickLoginWithPhoneR = [MARQuickLoginWithPhoneR new];
    quickLoginWithPhoneR.phone = self.phoneNumber;
    [MARUserNetworkManager quickLoginWithPhone:quickLoginWithPhoneR success:^(NSURLSessionTask *task, id responseObject) {
        MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
        if ([response isSuccess]) {
            MARUserInfoModel *userInfo = [MARUserInfoModel mar_modelWithJSON:response.body];
            MARGLOBALMODEL.userInfo = userInfo;
            NSLog(@"quick login success");
            
            UIViewController *settingVC = [UIViewController vcWithStoryboardName:kSBNAME_Mine storyboardId:kSBID_Mine_MineVC];
            [self mar_pushViewController:settingVC animated:YES];
            
        }
        else
            NSLog(@"quick login error");
        
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"quick login error : %@", error);
    }];
}


- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    if ([data isKindOfClass:[NSMutableDictionary class]]) {
        if ([data[@"operationType"] integerValue] == self.operationType) {
            NSInteger count = [data[@"count"] integerValue];
            if (count <= 0) {
                self.getCodeBtn.enabled = YES;
            }
            else
            {
                self.getCodeBtn.enabled = NO;
                [self.getCodeBtn setTitle:MARSTRWITHINT(count) forState:UIControlStateDisabled];
            }
        }
    }
}

@end
