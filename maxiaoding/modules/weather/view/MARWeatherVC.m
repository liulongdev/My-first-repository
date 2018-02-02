//
//  MARWeatherVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWeatherVC.h"
#import "MARALIAPINetworkManager.h"
#import "MARWeatherHeaderView.h"
#import "MARWeatherDayCell.h"
@interface MARWeatherVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MAAWeatherModel *weatherM;
@end

@implementation MARWeatherVC
@synthesize weatherM = _weatherM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"苏州天气";
    self.tableView.backgroundColor = [UIColor purpleColor];
    [self loadData];
//    [self weatherM];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData
{
    MAAGetWeatherR *getWeatherR = [MAAGetWeatherR new];
    getWeatherR.city = @"苏州";
    @weakify(self);
    [MARALIAPINetworkManager weather_getWeather:getWeatherR success:^(MAAWeatherModel *weatherM) {
        weak_self.weatherM = weatherM;
//        [weatherM updateToDB];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@">>>> error : %@", error);
    }];
}

- (MAAWeatherModel *)weatherM
{
    if (!_weatherM) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            _weatherM = ;
//            if (_cookCategoryMenuArray.count > 0) {
            BOOL flag = false;
            if (flag){
                mar_dispatch_async_on_main_queue(^{
                    [self.tableView reloadData];
                });
            }
            else
            {
                [self loadData];
            }
        });
    }
    return _weatherM;
}

- (void)setWeatherM:(MAAWeatherModel *)weatherM
{
    _weatherM = weatherM;
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        MARWeatherHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"MARWeatherHeaderView" owner:nil options:nil][0];
        
        [[[NSBundle mainBundle] loadNibNamed:@"MARWeatherHeaderView" owner:nil options:nil] firstObject];
        headerView.weatherModel = _weatherM;
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 355;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _weatherM.daily.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARWeatherDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWeatherDayCell" forIndexPath:indexPath];
    if (_weatherM.daily.count > indexPath.row) {
        [cell setCellData:_weatherM.daily[indexPath.row]];
    }
    return cell;;
}

@end
