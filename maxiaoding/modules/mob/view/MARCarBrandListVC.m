//
//  MARCarBrandListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCarBrandListVC.h"
#import <MobAPI/MobAPI.h>

@interface MARCarBrandListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MARCardBrandModel *> *carBrandArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *titleIndexArray;
@end

@implementation MARCarBrandListVC
@synthesize carBrandArray = _carBrandArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}


- (void)UIGlobal
{
    self.tableView.tableFooterView = [UIView new];
}

- (void)loadData
{
    if (self.carBrandArray.count > 0) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [self showActivityView:YES];
    [MobAPI sendRequest:[MOBACarRequest carBrandRequest] onResult:^(MOBAResponse *response) {
        [weakSelf showActivityView:NO];
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!response.error) {
            NSArray<MARCardBrandModel *> *cardBrandArray = [NSArray mar_modelArrayWithClass:[MARCardBrandModel class] json:response.responder[@"result"]];
            strongSelf.carBrandArray = cardBrandArray;
           [weakSelf.tableView reloadData]; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARCardBrandModel *model in cardBrandArray) {
                    [model updateToDB];
                }
            });
            
        }
        else
        {
            ShowErrorMessage([response.error localizedDescription], 1.5f);
            NSLog(@">>>> get carbrand error : %@", [response.error localizedDescription]);
        }
    }];
}

- (NSArray<MARCardBrandModel *> *)carBrandArray
{
    if (!_carBrandArray || ![_carBrandArray isKindOfClass:[NSArray class]] || _carBrandArray.count <= 0) {
        self.carBrandArray = (NSArray<MARCardBrandModel *> *)[MARCardBrandModel mar_getAllDBModelArray];
    }
    return _carBrandArray;
}

- (void)setCarBrandArray:(NSArray<MARCardBrandModel *> *)carBrandArray
{
    _carBrandArray = carBrandArray;
    [self.titleIndexArray removeAllObjects];
    for (MARCardBrandModel *model in carBrandArray) {
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

@end
