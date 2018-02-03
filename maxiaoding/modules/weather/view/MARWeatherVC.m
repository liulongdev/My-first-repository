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
@interface MARWeatherVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MAAWeatherModel *weatherM;
@end

@implementation MARWeatherVC
@synthesize weatherM = _weatherM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"苏州天气";
    [self loadData];
//    [self weatherM];
}

- (void)UIGlobal
{
    self.tableView.backgroundColor = [UIColor purpleColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 15;
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
//        if (weatherM.daily.count > 2) {
//            weatherM.daily = [[NSMutableArray arrayWithArray:weatherM.daily] subarrayWithRange:NSMakeRange(1, weatherM.daily.count - 1)];
//        }
        weak_self.weatherM = weatherM;
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
    return 335;
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
                NSString *weatherDesc = [NSString stringWithFormat:@"今天 : 现在%@。 最高气温%@º。 %@",todayWeatherInfoM.day.weather, todayWeatherInfoM.day.temphigh, toNightDesc];
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
