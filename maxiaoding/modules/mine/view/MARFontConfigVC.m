//
//  MARFontConfigVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/29.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARFontConfigVC.h"

@interface MARFontConfigVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *fontArray;
@end

@implementation MARFontConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"字体相关";
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)fontArray
{
    if (!_fontArray) {
        _fontArray = [UIFont familyNames];
    }
    return _fontArray;
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fontArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *fontName = self.fontArray[indexPath.row];
    cell.textLabel.text = fontName;
    
    cell.detailTextLabel.text = @"12345678abc你好马丁";
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:20];
    return cell;
}

@end
