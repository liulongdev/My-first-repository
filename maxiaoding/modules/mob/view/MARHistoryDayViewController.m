//
//  MARHistoryDayViewController.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHistoryDayViewController.h"
#import <MobAPI/MobAPI.h>
#import "MARHistoryDayTableCell.h"
#import "MARHistoryDayDetailVC.h"
#import "MARMonthDayView.h"
#import <Masonry.h>

@interface MARHistoryDayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MARMonthDayView* monthDayView;
@property (nonatomic, strong) NSArray *historyDayArray;

@end

@implementation MARHistoryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = nil;
    [self historyDayArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *naviBar = self.navigationController.navigationBar;
    [naviBar addSubview:self.monthDayView];
    self.monthDayView.mar_left = (kScreenWIDTH - self.monthDayView.mar_width)/2;
    
    [self.monthDayView addTarget:self action:@selector(getDataWithDateStr:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_monthDayView removeFromSuperview];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self refreshSortState];
}

- (void)getDataWithDateStr:(MARMonthDayView *)monthDayView
{
    self.dateStr = [NSString stringWithFormat:@"%02ld%02ld", (long)monthDayView.month, (long)monthDayView.day];
    _historyDayArray = nil;
    [self.tableView reloadData];
    [self loadData];
}

- (void)refreshSortState
{
    BOOL isDescSort = [MARUserDefault getBoolBy:USERDEFAULTKEY_HistoryDayDataDESCSort];
    NSString *sortStr = @"↓";
    if (!isDescSort) {
        sortStr = @"↑";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:sortStr style:UIBarButtonItemStyleDone target:self action:@selector(clickRightSorkBtnAction:)];
}

- (void)getDataAndReloadData
{
    _historyDayArray = [MARHistoryDayModel getHistoryDayArrayWithDateStr:self.dateStr];
    [self.tableView reloadData];
}

- (void)clickRightSorkBtnAction:(id)sender
{
    if (_historyDayArray.count > 0) {
        BOOL isDescSort = [MARUserDefault getBoolBy:USERDEFAULTKEY_HistoryDayDataDESCSort];
        [MARUserDefault setBool:!isDescSort key:USERDEFAULTKEY_HistoryDayDataDESCSort];
        [self refreshSortState];
        [self getDataAndReloadData];
    }
}

- (void)loadData
{
    if (self.historyDayArray.count > 0) {
        return;
    }
    
    [self showActivityView:YES];
    @weakify(self)
    [MARMobUtil loadHistoryListWithDateStr:self.dateStr callback:^(MOBAResponse *response, NSArray<MARHistoryDayModel *> *historyDayArray, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        if (!strong_self) return;
        if (!response.error) {
            strong_self->_historyDayArray = historyDayArray;
            [strong_self.tableView reloadData];
            if (historyDayArray.count > 0) {
                [strong_self hiddenEmptyView];
            }
            else
            {
                [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
            }
        }
        else
        {
            NSString *codeKey = MARSTRWITHINT(response.error.code);
            ShowErrorMessage(MARMOBUTIL.mobErrorDic[codeKey] ?: [response.error localizedDescription], 1.f);
            NSLog(@">>> get history error : %@", [response.error localizedDescription]);
            [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
    }];
}

- (NSArray *)historyDayArray
{
    if (!_historyDayArray) {
        static BOOL simpleAsync = NO;
        [self showActivityView:YES];
        @weakify(self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @strongify(self)
            if (!strong_self) return;
            if (!simpleAsync) {
                simpleAsync = YES;
                strong_self->_historyDayArray = [MARHistoryDayModel getHistoryDayArrayWithDateStr:strong_self.dateStr];
                if (strong_self->_historyDayArray.count <= 0) {
                    [strong_self loadData];
                }
                else
                {
                    mar_dispatch_async_on_main_queue(^{
                        [strong_self showActivityView:NO];
                        [strong_self.tableView reloadData];
                    });
                }
                simpleAsync = NO;
            }
        });
    }
    return _historyDayArray;
}

- (NSString *)dateStr
{
    if (!_dateStr || ![_dateStr isKindOfClass:[NSString class]] || _dateStr.length != 4) {
        MARGLOBALMANAGER.dataFormatter.dateFormat = @"MMdd";
        if (_date) {
            _dateStr = [MARGLOBALMANAGER.dataFormatter stringFromDate:_date];
        }
        else
            _dateStr = [MARGLOBALMANAGER.dataFormatter stringFromDate:[NSDate date]];
    }
    return _dateStr;
}

- (MARMonthDayView *)monthDayView
{
    if (!_monthDayView) {
        _monthDayView = [[MARMonthDayView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        _monthDayView.flowLayout.itemSize = CGSizeMake(80, 44);
        _monthDayView.backgroundColor = [UIColor clearColor];
    }
    return _monthDayView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyDayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARHistoryDayTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.historyDayArray.count > row) {
        [cell setCellData:self.historyDayArray[row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.historyDayArray.count > row) {
        [self performSegueWithIdentifier:@"goHistoryDayDetailVC" sender:self.historyDayArray[row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goHistoryDayDetailVC"]) {
        MARHistoryDayDetailVC *historyDayDetailVC = segue.destinationViewController;
        if ([historyDayDetailVC isKindOfClass:[MARHistoryDayDetailVC class]] && [sender isKindOfClass:[MARHistoryDayModel class]]) {
            historyDayDetailVC.historyDayModel = sender;
        }
    }
}

@end
