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
#import <MARCategory.h>
#import "MARWeatherChooseCityVC.h"
@interface MARWeatherVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MAAWeatherModel *weatherM;
@property (nonatomic, strong) MAAWeatherLocalCityModel *localCityModel;
@end

@implementation MARWeatherVC
{
    BOOL weatherLoading;
}

@synthesize weatherM = _weatherM;
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self weatherM];
}

- (void)UIGlobal
{
    self.tableView.backgroundColor = [UIColor purpleColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 15;
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:nil action:nil];
    @weakify(self)
    [rightBarBtn setMar_actionBlock:^(id sender) {
        @strongify(self)
        if (!strong_self) return;
        MARWeatherChooseCityVC *chooseCityVC = (MARWeatherChooseCityVC *)[UIViewController vcWithStoryboardName:kSBNAME_Weather storyboardId:kSBID_Weather_WeatherChooseCityVC];
        chooseCityVC.selectLoalCityMBlock = ^(MAAWeatherLocalCityModel *localCityM) {
            strong_self.localCityModel = localCityM;
            [strong_self weatherM];
        };
        [strong_self mar_pushViewController:chooseCityVC animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData
{
    if (!self.localCityModel) {
        return;
    }
    if (weatherLoading) {
        return;
    }
    weatherLoading = YES;
    MAAGetWeatherR *getWeatherR = [MAAGetWeatherR new];
    getWeatherR.cityid = self.localCityModel.cityid;
    @weakify(self);
    [self showActivityView:YES];
    [MARALIAPINetworkManager weather_getWeather:getWeatherR success:^(MAAWeatherModel *weatherM) {
//        if (weatherM.daily.count > 2) {
//            weatherM.daily = [[NSMutableArray arrayWithArray:weatherM.daily] subarrayWithRange:NSMakeRange(1, weatherM.daily.count - 1)];
//        }
        @strongify(self)
        if (!strong_self) return;
        strong_self->weatherLoading = NO;
        [strong_self showActivityView:NO];
        weak_self.weatherM = weatherM;
        weatherM.requestDate = [NSDate new];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weatherM updateToDB];
        });
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [weak_self showActivityView:NO];
        @strongify(self)
        if (!strong_self) return;
        strong_self->weatherLoading = NO;
        NSLog(@">>>> error : %@", error);
    }];
}

- (MAAWeatherLocalCityModel *)localCityModel
{
    if (!_localCityModel) {
        NSArray *cityArray = [MAAWeatherLocalCityModel searchWithWhere:nil orderBy:@"orderIndex asc" offset:self.pageIndex count:1];
        if (cityArray.count > 0) {
            _localCityModel = cityArray[0];
        }
    }
    return _localCityModel;
}

// 需要重新获取城市
- (void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
    _localCityModel = nil;
}

- (MAAWeatherModel *)weatherM
{
    if (self.localCityModel && (!_weatherM || ![_weatherM.cityid isEqual: self.localCityModel.cityid])) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            _weatherM = ;
//            if (_cookCategoryMenuArray.count > 0) {
            MAAWeatherModel *weatherModel = [MAAWeatherModel weatherModelWithCityId:self.localCityModel.cityid];
            BOOL flag = false;
            if (weatherModel && fabs([weatherModel.requestDate timeIntervalSince1970] - [[NSDate new] timeIntervalSince1970]) < 60 * 30) {
                flag = true;
            }
            mar_dispatch_async_on_main_queue(^{
                if (flag){
                    _weatherM = weatherModel;
                        [self.tableView reloadData];
                }
                else
                {
                    [self loadData];
                }
            });
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
    if (_weatherM) {
        return 335;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_weatherM) {
        return _weatherM.daily.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_weatherM.daily.count > indexPath.row) {
        MARWeatherDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARWeatherDayCell" forIndexPath:indexPath];
        [cell setCellData:_weatherM.daily[indexPath.row]];
        return cell;
    }
    else if (indexPath.row == _weatherM.daily.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customInfoTableCell" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        if (label && _weatherM.daily.count > 0) {
            BOOL isDay = [NSDate new].mar_hour < 18;
            NSString *toNightDesc = @"";
            if (isDay) {
                MAAWeatherDayInfoM *todayWeatherInfoM = _weatherM.daily[0];
                toNightDesc = [NSString stringWithFormat:@"今晚%@, 最低气温%@º。", todayWeatherInfoM.night.weather, todayWeatherInfoM.night.templow];
                NSString *weatherDesc = [NSString stringWithFormat:@"今天 : 现在%@, 气温%@º。 最高气温%@º。  %@",todayWeatherInfoM.day.weather, _weatherM.temp,  _weatherM.temphigh, toNightDesc];
                label.text = weatherDesc;
            }
            else
            {
                MAAWeatherDayInfoM *todayWeatherInfoM = _weatherM.daily[0];
                toNightDesc = [NSString stringWithFormat:@"现在%@, 最低气温%@º。", todayWeatherInfoM.night.weather, todayWeatherInfoM.night.templow];
                label.text = toNightDesc;
            }
        }
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"error"];
}

@end
