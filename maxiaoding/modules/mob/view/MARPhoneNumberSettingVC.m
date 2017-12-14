//
//  MARPhoneNumberSettingVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARPhoneNumberSettingVC.h"
#import <SMS_SDK/SMSSDK.h>
@interface MARPhoneNumberSettingVC ()
@property (strong, nonatomic) IBOutlet UITextField *areaCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTF;

@property (nonatomic, strong) NSDictionary *mobErrorDictionary;

- (IBAction)clickGetVerifyCodeAction:(id)sender;
- (IBAction)checkVerifyCodeAction:(id)sender;
- (IBAction)clickGetAreaCodeListAction:(id)sender;
@end

@implementation MARPhoneNumberSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)mobErrorDictionary
{
    if (![_mobErrorDictionary isKindOfClass:[NSDictionary class]] || _mobErrorDictionary.allKeys.count <= 0) {
        NSString *mobErrorPlistPath = [[NSBundle mainBundle] pathForResource:@"mob_error" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:mobErrorPlistPath];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            _mobErrorDictionary = dic;
        }
    }
    return _mobErrorDictionary;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickGetVerifyCodeAction:(id)sender {
    [self showActivityView:YES];
    __weak __typeof(self) weakSelf = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumberTF.text zone:self.areaCodeTF.text result:^(NSError *error) {
        [weakSelf showActivityView:NO];
        if (error != nil) {
            NSString *codeKey = [NSString stringWithFormat:@"%ld", (long)error.code];
            if (self.mobErrorDictionary[codeKey]) {
                ShowErrorMessage(self.mobErrorDictionary[codeKey], 1.5f);
            }
            else
                ShowErrorMessage([error localizedDescription], 1.5f);
            NSLog(@">>> getVerifyCode error : %@", [error localizedDescription]);
        }
        else
            ShowSuccessMessage(@"获取验证码成功", 1.5f);
    }];
}

- (IBAction)checkVerifyCodeAction:(id)sender {
    [self showActivityView:YES];
    __weak __typeof(self) weakSelf = self;
    [SMSSDK commitVerificationCode:self.verifyCodeTF.text phoneNumber:self.phoneNumberTF.text zone:self.areaCodeTF.text result:^(NSError *error) {
        [weakSelf showActivityView:NO];
        if (error != nil) {
            ShowErrorMessage([error localizedDescription], 1.5f);
        }
        else
            ShowSuccessMessage(@"验证成功", 1.5f);
    }];
    
}

- (IBAction)clickGetAreaCodeListAction:(id)sender {
    [self showActivityView:YES];
    __weak __typeof(self) weakSelf = self;
    [SMSSDK getCountryZone:^(NSError *error, NSArray *zonesArray) {
        [weakSelf showActivityView:NO];
        if (error != nil) {
            ShowErrorMessage([error localizedDescription], 1.5f);
            NSLog(@">>> getAreaCodeList error : %@", [error localizedDescription]);
        }
        else
        {
            NSLog(@">>> getAreaCodeList : %@", zonesArray);
        }
    }];
}
@end
