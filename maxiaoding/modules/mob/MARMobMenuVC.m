//
//  MARMobMenuVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobMenuVC.h"

static NSString * const mobTitle_wxArticle          = @"微信热门";
static NSString * const mobTitle_historyToday       = @"历史上的今天";
static NSString * const mobTitle_phoneNumberSetting = @"手机设置";
static NSString * const mobTitle_utilityTool        = @"实用工具";
static NSString * const mobTitle_carBrand           = @"汽车";
static NSString * const mobTitle_cookMenu           = @"菜谱";

static NSString * const mobTitle_testFunction       = @"测试";


@interface MARMobMenuVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation MARMobMenuVC

- (void)viewDidLoad {
    self.title = @"马小丁";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[mobTitle_wxArticle,
                        mobTitle_historyToday,
//                        mobTitle_phoneNumberSetting,
//                        mobTitle_utilityTool,
                        mobTitle_carBrand,
                        mobTitle_cookMenu,
                        
                        mobTitle_testFunction,
                        ];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.titleArray.count > row) {
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        label.text = self.titleArray[row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    if ([mobTitle_wxArticle isEqualToString:label.text]) {
        [self performSegueWithIdentifier:@"goArticleCategoryVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_wxArticle"];
    }
    else if ([mobTitle_historyToday isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goHistoryDayVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_historyDay"];
    }
    else if ([mobTitle_phoneNumberSetting isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goPhoneNumberSettingVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_phoneNumbeSetting"];
    }
    else if ([mobTitle_utilityTool isEqualToString:label.text])
    {
        
    }
    else if ([mobTitle_carBrand isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goCarBrandListVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_carBrand"];
    }
    else if ([mobTitle_cookMenu isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goCookCategoryListVC" sender:nil];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_cookCategoryList"];
    }
    else if ([mobTitle_testFunction isEqualToString:label.text])
    {
        [MARMobUtil test];
        [MARDataAnalysis setEventPage:@"MobMenuList" EventLabel:@"clickCell_test"];
    }
    
    
    
}

@end
