//
//  MARVideoFullVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/9.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARVideoFullVC.h"
#import <Masonry.h>
@interface MARVideoFullVC ()

@end

@implementation MARVideoFullVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenSystemVolume:YES];
    [self.view addSubview:self.playView];
}

- (void)setPlayView:(MARWYVideoPlayView *)playView
{
    _playView = playView;
    [self.playView removeFromSuperview];
    [self.view addSubview:self.playView];
    [self.playView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.leading.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.trailing.mas_equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotate
{
    return YES;
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
