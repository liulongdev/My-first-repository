//
//  MARMineVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMineVC.h"
#import <UIImageView+WebCache.h>

@interface MARMineVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MARMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTableHeaderView];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.mar_height/2;
}

- (void)updateTableHeaderView
{
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:MARGLOBALMODEL.userInfo.userImageIcon ?: @""] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    self.userNameLabel.text = MARGLOBALMODEL.userInfo.userNickName;
    
    CGFloat headerHeight = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableHeaderView.mar_height  = headerHeight;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableHeaderView.mar_height = headerHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = @"设置";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goSettingVC" sender:nil];
}


@end
