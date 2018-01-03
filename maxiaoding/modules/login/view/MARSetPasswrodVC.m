//
//  MARSetPasswrodVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/3.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARSetPasswrodVC.h"
#import "MARUserNetworkManager.h"

@interface MARSetPasswrodVC ()
@property (strong, nonatomic) IBOutlet UITextField *firstPasswordTF;
@property (strong, nonatomic) IBOutlet UITextField *secondPasswordTF;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)clickFinishBtnAction:(id)sender;

@end

@implementation MARSetPasswrodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickFinishBtnAction:(id)sender {
    if ([self.firstPasswordTF.text mar_stringByTrim].length  <= 0) {
        ShowInfoMessage(@"请输入密码", 1.f);
        return;
    }
    if (![self.firstPasswordTF.text isEqual:self.secondPasswordTF.text]) {
        ShowInfoMessage(@"两次输入的密码不一致", 1.f);
        return;
    }
    
    NSString *password = [self.firstPasswordTF.text mar_hmacSHA256StringWithKey:MARCRYPTOHMACSHA256KEY];
    MARSetPasswordR *setPasswordR = [MARSetPasswordR new];
    setPasswordR.userId = MARGLOBALMODEL.userInfo._id;
    setPasswordR.password = password;
    @weakify(self)
    [MARUserNetworkManager setPassword:setPasswordR success:^(NSURLSessionTask *task, id responseObject) {
        @strongify(self)
        if (!strong_self) return;
        MARNetworkResponse *response = [MARNetworkResponse mar_modelWithJSON:responseObject];
        if ([response isSuccess]) {
            ShowSuccessMessage(@"设置密码成功", 1.f);
            [strong_self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            ShowErrorMessage(@"设置密码失败", 1.5f);
            MARErrorLog(@"设置密码失败");
        }
    } failure:^(NSURLSessionTask *task, NSError *error) {
        ShowErrorMessage(@"设置密码失败！", 1.5f);
        MARErrorLog(@"设置密码失败 : %@", error);
    }];
}
@end
