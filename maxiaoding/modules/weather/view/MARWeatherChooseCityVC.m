//
//  MARWeatherChooseCityVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/7.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWeatherChooseCityVC.h"
#import "MARALIAPINetworkManager.h"

@interface MARWeatherChooseCityVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableViewBottom;
@property (nonatomic, strong) NSArray<MAAWeatherCityModel *> *cityArray;
@end

@implementation MARWeatherChooseCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.searchBar becomeFirstResponder];
}

- (void)loadData
{
    if ([MAAWeatherCityModel rowCountWithWhere:nil] > 0) {
        return;
    }
    [self showActivityView:YES];
    @weakify(self)
    [MARALIAPINetworkManager weather_getCitiesSuccess:^(NSArray<MAAWeatherCityModel *> *cityArray) {
        @strongify(self)
        if (!strong_self) return;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (MAAWeatherCityModel *model in cityArray) {
                [model updateToDB];
            }
            mar_dispatch_async_on_main_queue(^{
                [strong_self showActivityView:NO];
            });
        });
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@">>>>> error : %@", error);
    }];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Observer function
#pragma mark 键盘推出，隐藏动作
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSValue* keyRectVal = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyFrame = [keyRectVal CGRectValue];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.constraint_tableViewBottom.constant = keyFrame.size.height;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.constraint_tableViewBottom.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityInfoTableCell" forIndexPath:indexPath];
    if (self.cityArray.count > indexPath.row) {
        UILabel *label  = [cell viewWithTag:1];
        MAAWeatherCityModel *cityM = self.cityArray[indexPath.row];
        NSString *cityInfoStr = [NSString stringWithFormat:@"%@", cityM.city];
        label.text = cityInfoStr;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cityArray.count > indexPath.row) {
        MAAWeatherCityModel *cityM = _cityArray[indexPath.row];
        NSArray *localCityMArray = [MAAWeatherLocalCityModel cityArrayWhere:@{@"cityid":cityM.cityid ?: @""}];
        MAAWeatherLocalCityModel *localCityM = nil;
        if (localCityMArray.count > 0) {
            localCityM = localCityMArray[0];
        }
        else
        {
            localCityM = [MAAWeatherLocalCityModel localCityMWithWeatherCityM:cityM];
            localCityM.orderIndex = [MAAWeatherLocalCityModel rowCountWithWhere:nil];;
            [localCityM updateToDB];
        }
        if (localCityM && self.selectLoalCityMBlock) {
            self.selectLoalCityMBlock(localCityM);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - NSSearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadCityDataWithSearchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)reloadCityDataWithSearchText
{
    if ([self.searchBar.text mar_stringByTrim].length == 0) {
        _cityArray = nil;
        [self.tableView reloadData];
    }
    else
    {
        _cityArray = [MAAWeatherCityModel cityArrayWithLikeKey:self.searchBar.text];
        [self.tableView reloadData];
    }
}



@end
