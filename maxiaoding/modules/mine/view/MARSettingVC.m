//
//  MARSettingVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARSettingVC.h"
#import <UIImageView+WebCache.h>

NSString * const settingCellTitle_cache = @"清除缓存";


@interface MARSettingVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSByteCountFormatter *byteFormatter;

@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation MARSettingVC
{
    BOOL isCaculatingSDImageDiskSize;
    NSInteger sdImageCount;
    NSInteger sdImageDiskSize;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self caculateSDImageDiskSize];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
}

- (NSArray *)titleArray
{
    return @[settingCellTitle_cache];
}

- (void)caculateSDImageDiskSize
{
    isCaculatingSDImageDiskSize = YES;
    [self.tableView reloadData];
    @weakify(self)
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        @strongify(self);
        if (!strong_self) return;
        strong_self->isCaculatingSDImageDiskSize = NO;
        strong_self->sdImageCount = fileCount;
        strong_self->sdImageDiskSize = totalSize;
        [strong_self.tableView reloadData];
    }];
}

- (NSByteCountFormatter *)byteFormatter
{
    if (!_byteFormatter) {
        _byteFormatter = [[NSByteCountFormatter alloc] init];
    }
    return _byteFormatter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.titleArray.count > indexPath.row) {
        cell.textLabel.text = self.titleArray[0];
    }
    if ([cell.textLabel.text isEqualToString:settingCellTitle_cache]) {
        if (isCaculatingSDImageDiskSize) {
            cell.detailTextLabel.text = nil;
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [activityIndicatorView startAnimating];
            cell.accessoryView = activityIndicatorView;
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张图片-%@", (long)sdImageCount, [self.byteFormatter stringFromByteCount:sdImageDiskSize]];
            cell.accessoryView = nil;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([settingCellTitle_cache isEqualToString:cell.textLabel.text]) {
        [self _clearImageCache];
    }
}

- (void)_clearImageCache
{
    @weakify(self)
    [[SDImageCache sharedImageCache] clearMemory];
    isCaculatingSDImageDiskSize = YES;
    [self.tableView reloadData];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        @strongify(self)
        if (!strong_self) return;
        [strong_self caculateSDImageDiskSize];
    }];
}

@end
