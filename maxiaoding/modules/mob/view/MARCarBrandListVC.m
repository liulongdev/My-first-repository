//
//  MARCarBrandListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCarBrandListVC.h"
#import <MobAPI/MobAPI.h>
#import "MARCarSeriesVC.h"

@interface MARCarBrandListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MARCarBrandModel *> *carBrandArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *titleIndexArray;
@end

@implementation MARCarBrandListVC
@synthesize carBrandArray = _carBrandArray;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
}

- (void)loadData
{
    if (self.carBrandArray.count > 0) {
        return;
    }
    [self showActivityView:YES];
    @weakify(self)
    [MARMobUtil loadCarBrandListCallback:^(MOBAResponse *response, NSArray<MARCarBrandModel *> *cardBrandArray, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        if (!response.error) {
            NSArray<MARCarBrandModel *> *cardBrandArray = [NSArray mar_modelArrayWithClass:[MARCarBrandModel class] json:response.responder[@"result"]];
            strong_self.carBrandArray = cardBrandArray;
            [strong_self.tableView reloadData];
            if (cardBrandArray.count > 0) {
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
            NSLog(@">>> get car brand list error : %@", [response.error localizedDescription]);
            [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
    }];
}

- (NSArray<MARCarBrandModel *> *)carBrandArray
{
    if (!_carBrandArray || ![_carBrandArray isKindOfClass:[NSArray class]] || _carBrandArray.count <= 0) {
        static BOOL simpleAsync = NO;
        [self showActivityView:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!simpleAsync) {
                simpleAsync = YES;
                self.carBrandArray = (NSArray<MARCarBrandModel *> *)[MARCarBrandModel mar_getAllDBModelArray];
                if (_carBrandArray.count <= 0) {
                    [self loadData];
                }
                else
                {
                    mar_dispatch_async_on_main_queue(^{
                        [self showActivityView:NO];
                        [self.tableView reloadData];
                    });
                }
                simpleAsync = NO;
            }
        });
    }
    return _carBrandArray;
}

- (void)setCarBrandArray:(NSArray<MARCarBrandModel *> *)carBrandArray
{
    _carBrandArray = carBrandArray;
    [self.titleIndexArray removeAllObjects];
    for (MARCarBrandModel *model in carBrandArray) {
        NSString *name = model.name;
        if (name.length > 1) {
            [self.titleIndexArray addObject:[name substringToIndex:1]];
        }
        else
            [self.titleIndexArray addObject:name ?: @""];
    }
}

- (NSMutableArray<NSString *> *)titleIndexArray
{
    if (!_titleIndexArray) {
        _titleIndexArray = [NSMutableArray arrayWithCapacity:MAX(16, _carBrandArray.count)];
    }
    return _titleIndexArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carBrandArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.mar_width, height)];
//    view.backgroundColor = RGBHEX(0xf8f8f8);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.mar_width - 15 * 2, height)];
//    [view addSubview:label];
//    if (self.carBrandArray.count > section) {
//        label.text = self.carBrandArray[section].name;
//    }
//    return view;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.carBrandArray.count > section) {
        return self.carBrandArray[section].name;
    }
    return @"";
}

//添加索引栏标题数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.titleIndexArray;
//    return @[@"啊", @"不", @"从", @"的"];
}

//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.carBrandArray.count > section) {
        return self.carBrandArray[section].son.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableviewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    NSInteger row = indexPath.row;
    if (self.carBrandArray.count > indexPath.section) {
        NSArray<MARCarTypeInfoModel *> *carTypeInfoArray = self.carBrandArray[indexPath.section].son;
        if (carTypeInfoArray.count > row) {
            cell.textLabel.text = carTypeInfoArray[row].car;
            cell.detailTextLabel.text = carTypeInfoArray[row].type;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.carBrandArray.count > indexPath.section) {
        NSArray<MARCarTypeInfoModel *> *carTypeInfoArray = self.carBrandArray[indexPath.section].son;
        if (carTypeInfoArray.count > row) {
            [self performSegueWithIdentifier:@"goCarSeriesVC" sender:carTypeInfoArray[row]];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goCarSeriesVC"]) {
        MARCarSeriesVC *cardSeriesVC = segue.destinationViewController;
        if ([cardSeriesVC isKindOfClass:[MARCarSeriesVC class]] && [sender isKindOfClass:[MARCarTypeInfoModel class]]) {
            cardSeriesVC.cardTypeInfoModel = sender;
        }
    }
}

@end
