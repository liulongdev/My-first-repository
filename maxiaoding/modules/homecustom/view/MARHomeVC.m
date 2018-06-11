//
//  MARHomeVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARHomeVC.h"
#import "MARHomeDateView.h"
#import <Masonry.h>

@interface MARHomeVC ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrolliew;

@end

@implementation MARHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MARAdjustsScrollViewInsets_NO(self.scrolliew, self);
    self.view.backgroundColor = RGBHEX(0xCDAF95);
    MARHomeDateView *view = [MARHomeDateView nibView];
    [self.scrolliew addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrolliew);
        make.leading.mas_equalTo(self.scrolliew);
        make.trailing.mas_equalTo(self.scrolliew);
        make.width.mas_equalTo(self.scrolliew);
    }];
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
