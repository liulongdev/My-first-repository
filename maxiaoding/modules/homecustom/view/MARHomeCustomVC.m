//
//  MARHomeCustomVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeCustomVC.h"
#import <Masonry.h>
#import "MARHomeCustomTableCell.h"
#import "MARHomeDateView.h"

@interface MARHomeCustomVC ()<UITableViewDataSource, UITableViewDelegate>
#pragma mark - UI
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MARHomeCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mar_preferredNavigationBarHidden = YES;
    [self setup];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:@"MARHomeCustomTableCell" bundle:nil] forCellReuseIdentifier:@"MARHomeCustomTableCell"];
    }
    return _tableView;
}


- (void)setup
{
    [self.view addSubview:self.tableView];
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.leading.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.trailing.mas_equalTo(self.view);
    }];
}

- (void)UIGlobal
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.mar_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARHomeCustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARHomeCustomTableCell" forIndexPath:indexPath];
    
    [cell.marContentView mar_removeAllSubviews];
    UIView *view = [MARHomeDateView nibView];
    [cell.marContentView addSubview:view];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    __weak __typeof(self) weakSelf = self;
    [cell setBottomAppearBlock:^{
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        [weakSelf.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    return cell;
}

@end
