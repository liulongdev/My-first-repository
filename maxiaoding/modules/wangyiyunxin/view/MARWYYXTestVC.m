//
//  MARWYYXTestVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/5/18.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYYXTestVC.h"
#import "MARNetworkManager.h"
#import <NSString+MAREX.h>
#import "MARWYYXNetworkManager.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMKit.h>
#import "MARSessionViewController.h"
@interface MARWYYXTestVC ()
- (IBAction)clickTestBtnAction:(id)sender;
- (IBAction)clickSendBtnAction:(id)sender;
- (IBAction)clickContactBtnAction:(id)sender;

@end

@implementation MARWYYXTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickTestBtnAction:(id)sender {
    
    NSString *url = @"https://api.netease.im/nimserver/user/refreshToken.action";
    NSLog(@"url : %@", url);
    __weak __typeof(self) weakSelf = self;
    
    
    [[[NIMSDK sharedSDK] loginManager] login:@"13218189892" token:[@"111111" mar_md5String]  completion:^(NSError * _Nullable error) {
        if (error) {
            MARLog(@"error : %@", error);
            return;
        }
        [weakSelf clickContactBtnAction:nil];
        MARLog(@"login success");
    }];
    
    return;
    [MARWYYXNetworkManager mar_post:url parameters:@{@"accid":@"1111"} success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"response : %@", responseObject);
        NSString *accid = responseObject[@"info"][@"accid"];
        NSString *token = responseObject[@"info"][@"token"];
        
        [[[NIMSDK sharedSDK] loginManager] login:accid token:token completion:^(NSError * _Nullable error) {
            if (error) {
                MARLog(@"error : %@", error);
                return;
            }
            [weakSelf clickContactBtnAction:nil];
            MARLog(@"login success");
        }];
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@"error : %@", error);
    }];
    
    
    
}

- (IBAction)clickSendBtnAction:(id)sender {
    NIMSession *ssession = [NIMSession session:@"110" type:NIMSessionTypeP2P];
    MARSessionViewController *vc = [[MARSessionViewController alloc] initWithSession:ssession];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    NIMSession *session = [NIMSession session:@"110" type:NIMSessionTypeP2P];
    // 构造出具体消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text        = @"真的哦";
    // 错误反馈对象
    NSError *error = nil;
    // 发送消息
    BOOL success = [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
    NSLog(@">>>> success : %d", success);
    if (error) {
        NSLog(@">>>> send message : %@", [error localizedDescription]);
    }
    
}

- (IBAction)clickContactBtnAction:(id)sender {
    NIMSessionListViewController *sessionListVc = [[NIMSessionListViewController alloc] init];
    [self.navigationController pushViewController:sessionListVc animated:YES];
}

- (NSDictionary *)requestHeader
{
    NSString *currentTime = [NSString stringWithFormat:@"%.f", [[NSDate new] timeIntervalSince1970]];
    NSString *appKey = @"f98bfbd723373582824634e8699d0d77";
    NSString *secretKey = @"8f300abc0e68";
    NSString *randomUUID = [NSString mar_stringWithUUID];
    NSString *signature = [[[secretKey stringByAppendingString:randomUUID] stringByAppendingString:currentTime] mar_sha1String];
    NSDictionary *header = @{
                             @"AppKey":appKey,
                             @"Nonce":randomUUID,
                             @"CurTime": currentTime,
                             @"CheckSum": signature
                             };
    return header;
}

@end
