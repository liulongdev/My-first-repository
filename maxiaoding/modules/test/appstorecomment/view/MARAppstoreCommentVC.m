//
//  MARAppstoreCommentVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/7/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARAppstoreCommentVC.h"
#import <StoreKit/StoreKit.h>

@interface MARAppstoreCommentVC () <SKStoreProductViewControllerDelegate>

- (IBAction)gotoAppstoreWriteReview:(id)sender;
- (IBAction)appstoreJustScoreInside:(id)sender;
- (IBAction)appstoreWriteReviewInside:(id)sender;


@end

@implementation MARAppstoreCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)appsotreCommentInside
{
    if (@available(iOS 10.3, *))
    {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {// iOS 10.3 以上支持
            //防止键盘遮挡
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
}

- (void)gotoAppsotreComment
{
    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"842495919"];//替换为对应的APPID
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
}

- (void)appsotreCommentInside2
{
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    
    storeProductViewContorller.delegate = self;
    
    //加载App Store视图展示
    [storeProductViewContorller loadProductWithParameters:
     @{SKStoreProductParameterITunesItemIdentifier : @"842495919"} completionBlock:^(BOOL result, NSError *error) {
         
         if(error) {
             NSLog(@">>>>>  error : %@", [error localizedDescription]);
         } else {
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }];
             
         }
     }];
}

// 代理方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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

- (IBAction)gotoAppstoreWriteReview:(id)sender {
    [self gotoAppsotreComment];
}

- (IBAction)appstoreJustScoreInside:(id)sender {
    [self appsotreCommentInside];
}

- (IBAction)appstoreWriteReviewInside:(id)sender {
    [self appsotreCommentInside2];
}
@end
