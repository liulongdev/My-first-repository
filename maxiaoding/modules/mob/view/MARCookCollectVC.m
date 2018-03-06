//
//  MARCookCollectVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/3/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARCookCollectVC.h"
#import "MARCookInfoTableCell.h"
#import "MARCookDetailVC.h"

@interface MARCookCollectVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MARCookDetailModel *> *cookArray;

@end

@implementation MARCookCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self cookArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _cookArray = nil;
    [self cookArray];
}

- (NSMutableArray<MARCookDetailModel *> *)cookArray
{
    if (!_cookArray) {
        [self hiddenEmptyView];
        [self showActivityView:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _cookArray = [MARCookDetailModel searchWithWhere:nil];
            mar_dispatch_async_on_main_queue(^{
                if (_cookArray.count <= 0) {
                    [self showEmptyViewWithDescription:@"本地无收藏的菜单"];
                }
                [self showActivityView:NO];
                [self.tableView reloadData];
            });
        });
    }
    return _cookArray;
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"MARCookInfoTableCell" bundle:nil] forCellReuseIdentifier:@"MARCookInfoTableCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARCookInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARCookInfoTableCell" forIndexPath:indexPath];
    if (_cookArray.count > indexPath.row) {
        [cell setCellData:_cookArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_cookArray.count > row) {
        MARCookDetailModel *model = _cookArray[row];
        if (model.recipe.method.count > 0 || model.recipe.ingredients || model.recipe.sumary) {
            MARCookDetailVC *cookDetailVC = (MARCookDetailVC *)[UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_CookDetailVC];
            cookDetailVC.cookDetail = model;
            [self mar_pushViewController:cookDetailVC animated:YES];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_cookArray.count > indexPath.row) {
            MARCookDetailModel *model = _cookArray[indexPath.row];
            BOOL deletaFlag = [model deleteToDB];
            if (deletaFlag) {
                [_cookArray removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

@end
