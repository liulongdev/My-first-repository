//
//  MARCookCategoryListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookCategoryListVC.h"
#import "MARSearchCookVC.h"
@interface MARCookCategoryListVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<MARCookCategoryMenuModel *> *cookCategoryMenuArray;

@end

@implementation MARCookCategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜谱";
    [self cookCategoryMenuArray];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    if (self.isSelectStyle) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goSearchCookVC:)];
    }
}

- (NSArray<MARCookCategoryMenuModel *> *)cookCategoryMenuArray
{
    if (!_cookCategoryMenuArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _cookCategoryMenuArray = (NSArray<MARCookCategoryMenuModel *> *)[MARCookCategoryMenuModel mar_getAllDBModelArray];
            
            mar_dispatch_async_on_main_queue(^{
                if (_cookCategoryMenuArray.count > 0) {
                    [self.tableView reloadData];
                }
                else
                {
                    [self loadData];
                }
            });
        });
    }
    return _cookCategoryMenuArray;
}

- (void)loadData
{
    @weakify(self)
    [MARMobUtil loadCookCategoriesCallback:^(MOBAResponse *response, NSArray<MARCookCategoryMenuModel *> *cookCategoryMenuArray, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        if (!response.error) {
            strong_self->_cookCategoryMenuArray = cookCategoryMenuArray;
            [strong_self.tableView reloadData];
            if (cookCategoryMenuArray.count > 0) {
                [strong_self hiddenEmptyView];
            }
            else
            {
                [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
            }
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
            [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
    }];
}

- (void)goSearchCookVC:(id)sender
{
    [self performSegueWithIdentifier:@"goSearchCookVC" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cookCategoryMenuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_cookCategoryMenuArray.count > section) {
        return _cookCategoryMenuArray[section].childs.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_cookCategoryMenuArray.count > section) {
        return _cookCategoryMenuArray[section].name;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSInteger row = indexPath.row;
    if (_cookCategoryMenuArray.count > indexPath.section) {
        if (_cookCategoryMenuArray[indexPath.section].childs.count > row) {
            MARCookCategoryModel *model = _cookCategoryMenuArray[indexPath.section].childs[row];
            cell.textLabel.text = model.name;
            if (self.isSelectStyle && [model isEqual:self.selectCookCategory]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelectStyle) {
        [MARDataAnalysis setEventPage:@"cookCategoryList" EventLabel:@"select_cookCategory"];
    }
    else
        [MARDataAnalysis setEventPage:@"cookCategoryList" EventLabel:@"click_cookCategory_to_cookSearchPage"];
    NSInteger row = indexPath.row;
    if (_cookCategoryMenuArray.count > indexPath.section) {
        if (_cookCategoryMenuArray[indexPath.section].childs.count > row) {
            MARCookCategoryModel *model = _cookCategoryMenuArray[indexPath.section].childs[row];
            // 选择模式
            if (self.isSelectStyle) {
                if ([model isEqual:self.selectCookCategory]) {
                    self.selectCookCategory = nil;
                }
                else
                    self.selectCookCategory = model;
                if (self.selectedCallback) {
                    self.selectedCallback(self.selectCookCategory);
                }
                [self.tableView reloadData];
            }
            else
            {
                [self performSegueWithIdentifier:@"goSearchCookVC" sender:model];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goSearchCookVC"]) {
        MARSearchCookVC *searchCookVC = segue.destinationViewController;
        if ([searchCookVC isKindOfClass:[MARSearchCookVC class]]) {
            if ([sender isKindOfClass:[MARCookCategoryModel class]]) {
                searchCookVC.cookCategoryModel = sender;
            }
        }
    }
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    if (type == kMARNotificationType_NetworkChangedEnabel) {
        [self cookCategoryMenuArray];
    }
}

@end
