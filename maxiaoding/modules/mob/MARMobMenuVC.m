//
//  MARMobMenuVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMobMenuVC.h"

static NSString * const mobTitle_wxArticle = @"微信热门";
static NSString * const mobTitle_historyToday = @"历史上的今天";

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
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[mobTitle_wxArticle,
                        mobTitle_historyToday];
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
    }
    else if ([mobTitle_historyToday isEqualToString:label.text])
    {
        [self performSegueWithIdentifier:@"goHistoryDayVC" sender:nil];
    }
}

@end
