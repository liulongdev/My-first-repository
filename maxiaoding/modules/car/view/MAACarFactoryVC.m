//
//  MAACarFactoryVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAACarFactoryVC.h"
#import "MARALIAPINetworkManager.h"
#import "MAACarTypeVC.h"
//"carTypeCell"
@interface MAACarFactoryVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSArray<MAACarFactoryM *> *carFactoryArray;

@end

@implementation MAACarFactoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self carFactoryArray];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
}

- (NSArray<MAACarFactoryM *> *)carFactoryArray
{
    if (!_carFactoryArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _carFactoryArray = [MAACarFactoryM carFactoryArrayWithBrandId:self.carBrandId];
            mar_dispatch_async_on_main_queue(^{
                if (_carFactoryArray.count > 0) {
                    [self.tableView reloadData];
                }
                else
                {
                    [self loadData];
                }
            });
        });
    }
    return _carFactoryArray;
}

- (void)loadData
{
    [MARDataAnalysis setEventPage:@"carFactoryVC" EventLabel:@"loaddata_carFactoryList"];
    @weakify(self);
    [self showActivityView:YES];
    [MARALIAPINetworkManager car_getCarFactoriesByBrandID:self.carBrandId success:^(NSArray<MAACarFactoryM *> *carFactoryArray) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        strong_self.carFactoryArray = carFactoryArray;
        [strong_self.tableView reloadData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (MAACarFactoryM *model in carFactoryArray) {
                [model updateToDB];
            }
        });
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@">>>>> error : %@", error);
        [weak_self showActivityView:NO];
    }];
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _carFactoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.mar_width, height)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *carFactoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWIDTH - 15 * 2, height)];
    carFactoryNameLabel.textColor = RGBHEX(0x333333);
    carFactoryNameLabel.font = MARFont(15.f);
    if (_carFactoryArray.count > section) {
        carFactoryNameLabel.text = _carFactoryArray[section].name;
    }
    [headerView addSubview:carFactoryNameLabel];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWIDTH, 0.5)];
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 1, kScreenWIDTH, 0.5)];
    topLineView.backgroundColor = bottomLineView.backgroundColor = RGBHEX(0xe0e0e0);
    if (section !=0) {
        [headerView addSubview:topLineView];
    }
    [headerView addSubview:bottomLineView];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_carFactoryArray.count > section)
    {
        return _carFactoryArray[section].carlist.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carTypeCell" forIndexPath:indexPath];
    if (_carFactoryArray.count > indexPath.section && _carFactoryArray[indexPath.section].carlist.count > indexPath.row)
    {
        MAACarTypeM *carTypeM = _carFactoryArray[indexPath.section].carlist[indexPath.row];
        UILabel *carFactoryNameLabel = [cell viewWithTag:1];
        UILabel *carFactorySaleStutasLabel = [cell viewWithTag:2];
        UIImageView *imageView = [cell viewWithTag:3];
        
        NSString *factoryName = (![carTypeM isKindOfClass:[NSString class]] || [carTypeM.fullname mar_stringByTrim].length == 0) ? carTypeM.name : carTypeM.fullname;
        carFactoryNameLabel.text = [NSString stringWithFormat:@"%@", factoryName];
        if (carTypeM.list.count > 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            carFactorySaleStutasLabel.text = [NSString stringWithFormat:@"%@ (%ld)", carTypeM.salestate, (long)carTypeM.list.count];
        }
        else
        {
            carFactorySaleStutasLabel.text = carTypeM.salestate;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [imageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:carTypeM.logo] errorImage:[UIImage imageNamed:@"icon_car_brands"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.carFactoryArray.count > indexPath.section && self.carFactoryArray[indexPath.section].carlist.count > indexPath.row && self.carFactoryArray[indexPath.section].carlist[indexPath.row].list.count > 0) {
        [MARDataAnalysis setEventPage:@"carFactoryVC" EventLabel:@"car_clickcell_carfactory"];
        [self performSegueWithIdentifier:@"goMAACarTypeVC" sender:self.carFactoryArray[indexPath.section].carlist[indexPath.row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MAACarTypeVC *carTypeVC = segue.destinationViewController;
    if ([carTypeVC isKindOfClass:[MAACarTypeVC class]]) {
        if ([sender isKindOfClass:[MAACarTypeM class]]) {
            MAACarTypeM *carTypeM = sender;
            carTypeVC.carTypeM = carTypeM;
            carTypeVC.title = (![carTypeM isKindOfClass:[NSString class]] || [carTypeM.fullname mar_stringByTrim].length == 0) ? carTypeM.name : carTypeM.fullname;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
