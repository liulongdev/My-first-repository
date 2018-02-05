//
//  MAACarBrandListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAACarBrandListVC.h"
#import "MARALIAPINetworkManager.h"
#import "MAACarFactoryVC.h"
@interface MAACarBrandListVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *carBrandDic;
@property (nonatomic, strong) NSArray<MAACarBrandM *> *carBrandArray;
@property (nonatomic, strong) NSArray* initialArray;
@end

@implementation MAACarBrandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self carBrandArray];
    // Do any additional setup after loading the view.
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
}

- (NSMutableDictionary *)carBrandDic
{
    if (!_carBrandDic) {
        _carBrandDic = [NSMutableDictionary dictionaryWithCapacity:1<<5];
    }
    return _carBrandDic;
}

- (NSArray *)initialArray
{
    if (!_initialArray) {
        if (self.carBrandDic.count > 0) {
            _initialArray = [self.carBrandDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
        }
    }
    return _initialArray;
}

- (void)wrapperCarBrandData
{
    if (_carBrandArray.count > 0) {
        for (MAACarBrandM *model in _carBrandArray) {
            NSMutableArray *brandArray = self.carBrandDic[model.initial ?: @""];
            if (!brandArray) {
                brandArray = [NSMutableArray arrayWithCapacity:1<<5];
                self.carBrandDic[model.initial ?: @""] = brandArray;
            }
            [brandArray addObject:model];
        }
    }
}

- (NSArray<MAACarBrandM *> *)carBrandArray
{
    if (!_carBrandArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _carBrandArray = (NSArray<MAACarBrandM *> *)[MAACarBrandM mar_getAllDBModelArray];
            mar_dispatch_async_on_main_queue(^{
                if (_carBrandArray.count > 0) {
                    [self wrapperCarBrandData];
                    [self.tableView reloadData];
                }
                else
                {
                    [self loadData];
                }
            });
        });
    }
    return _carBrandArray;
}

- (void)loadData
{
    @weakify(self)
    [self showActivityView:YES];
    [MARALIAPINetworkManager car_getAllBrandSuccess:^(NSArray<MAACarBrandM *> *carBrandArray) {
        @strongify(self)
        if (!strong_self) return;
        strong_self.carBrandArray = carBrandArray;
        [strong_self wrapperCarBrandData];
        [strong_self.tableView reloadData];
        for (MAACarBrandM *model in carBrandArray) {
            [model updateToDB];
        }
        [strong_self showActivityView:NO];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        NSLog(@">>>> error ; %@", error);
        [weak_self showActivityView:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
//添加索引栏标题数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.initialArray;
}

//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carBrandDic.count;
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
    UILabel *initialLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, kScreenWIDTH - 15 * 2, height - 8)];
    initialLabel.textColor = RGBHEX(0x333333);
    initialLabel.font = MARFont(15.f);
    
    if (self.initialArray.count > section) {
        initialLabel.text = self.initialArray[section];
    }
    [headerView addSubview:initialLabel];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWIDTH - 15, 0.5)];
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
    if (self.initialArray.count > section) {
        return [self.carBrandDic[self.initialArray[section]] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardBrandCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    if (self.initialArray.count > indexPath.section) {
        NSArray *brandArray = self.carBrandDic[self.initialArray[indexPath.section]];
        if ([brandArray isKindOfClass:[NSArray class]] && brandArray.count > indexPath.row) {
            MAACarBrandM *carBrandM = brandArray[indexPath.row];
            [imageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:carBrandM.logo] errorImage:[UIImage imageNamed:@"icon_car_brands"]];
            label.text = carBrandM.name;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.initialArray.count > indexPath.section) {
        NSArray *brandArray = self.carBrandDic[self.initialArray[indexPath.section]];
        if ([brandArray isKindOfClass:[NSArray class]] && brandArray.count > indexPath.row) {
            MAACarBrandM *carBrandM = brandArray[indexPath.row];
            [self performSegueWithIdentifier:@"goMAACarFactoryVC" sender:carBrandM];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MAACarFactoryVC *carFactoryVC = segue.destinationViewController;
    if ([carFactoryVC isKindOfClass:[MAACarFactoryVC class]]) {
        if ([sender isKindOfClass:[MAACarBrandM class]]) {
            MAACarBrandM *model = sender;
            carFactoryVC.carBrandId = model.id;
            carFactoryVC.title = model.name;
        }
    }
}

@end
