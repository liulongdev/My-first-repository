//
//  MARSessionViewController.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/5/18.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARSessionViewController.h"

@interface MARSessionViewController ()

@end

@implementation MARSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
