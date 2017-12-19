//
//  MARSettingVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARSettingVC.h"
#import <UIImageView+WebCache.h>
@interface MARSettingVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSByteCountFormatter *byteFormatter;
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

- (void)caculateSDImageDiskSize
{
    [self.tableView reloadData];
    isCaculatingSDImageDiskSize = YES;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = @"缓存";
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张图片、%@", (long)[[SDImageCache sharedImageCache] getDiskCount], [self.byteFormatter stringFromByteCount:[[SDImageCache sharedImageCache] getSize]]];
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
    return cell;
}
@end
