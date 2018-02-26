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
#import <Masonry.h>
@interface MAACarBrandListVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) NSMutableDictionary *carBrandDic;
@property (nonatomic, strong) NSArray<MAACarBrandM *> *carBrandArray;
@property (nonatomic, strong) NSArray* initialArray;
@property (nonatomic, strong) UIBarButtonItem *rightBarBtn;
@property (nonatomic, assign) BOOL isTableListStyle;

@property (nonatomic, strong) UIButton *displayStyleBtn;

@end

NSString * const MAACarBrandListVCListTableStyleKey = @"MAACarBrandListVCListTableStyleKey";

@implementation MAACarBrandListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self carBrandArray];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    MARAdjustsScrollViewInsets_NO(self.collectionView, self);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    NSInteger numberOfline = 4;
    CGFloat itemSpace = 20;
    CGFloat width = ((kScreenWIDTH - self.collectionFlowLayout.sectionInset.left - self.collectionFlowLayout.sectionInset.right) - itemSpace * (numberOfline - 1)) / numberOfline  - numberOfline;
    self.collectionFlowLayout.itemSize = CGSizeMake(width, width);
    self.collectionFlowLayout.minimumLineSpacing = itemSpace;
    self.collectionFlowLayout.minimumInteritemSpacing = itemSpace;
    
    if (self.isHomeStyle) {
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        self.collectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.view addSubview:self.displayStyleBtn];
        [self.displayStyleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_topLayoutGuide);
            make.trailing.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(100, 44));
        }];
    }
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
    if (!_carBrandDic || self.carBrandDic.count == 0) {
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
}

- (NSArray<MAACarBrandM *> *)carBrandArray
{
    if (!_carBrandArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _carBrandArray = (NSArray<MAACarBrandM *> *)[MAACarBrandM mar_getAllDBModelArray];
            mar_dispatch_async_on_main_queue(^{
                if (_carBrandArray.count > 0) {
                    [self p_reloadCollectionData];
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

- (UIBarButtonItem *)rightBarBtn
{
    if (!_rightBarBtn) {
        _rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        @weakify(self)
        [_rightBarBtn setMar_actionBlock:^(id sender) {
            weak_self.isTableListStyle = !weak_self.isTableListStyle;
            [weak_self p_reloadCollectionData];
        }];
    }
    return _rightBarBtn;
}

- (BOOL)isTableListStyle
{
    return [MARUserDefault getBoolBy:MAACarBrandListVCListTableStyleKey];
}

- (void)setIsTableListStyle:(BOOL)isTableListStyle
{
    [MARDataAnalysis setEventPage:@"carBrandListVC" EventLabel:@"car_click_display_style"];
    [MARUserDefault setBool:isTableListStyle key:MAACarBrandListVCListTableStyleKey];
}

- (UIButton *)displayStyleBtn
{
    if (!_displayStyleBtn) {
        _displayStyleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_displayStyleBtn setTitle:@"" forState:UIControlStateNormal];
        [_displayStyleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        @weakify(self)
        [_displayStyleBtn mar_addActionBlock:^(id sender) {
            @strongify(self)
            if (!strong_self) return;
            strong_self.isTableListStyle = !strong_self.isTableListStyle;
            [strong_self p_reloadCollectionData];
        } forState:UIControlEventTouchUpInside];
    }
    return _displayStyleBtn;
}

- (void)loadData
{
    [MARDataAnalysis setEventPage:@"carBrandListVC" EventLabel:@"loaddata_carBrandList"];
    @weakify(self)
    [self showActivityView:YES];
    [MARALIAPINetworkManager car_getAllBrandSuccess:^(NSArray<MAACarBrandM *> *carBrandArray) {
        @strongify(self)
        if (!strong_self) return;
        strong_self.carBrandArray = carBrandArray;
        [strong_self p_reloadCollectionData];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (MAACarBrandM *model in carBrandArray) {
                [model updateToDB];
            }
        });
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
        [MARDataAnalysis setEventPage:@"carBrandListVC" EventLabel:@"car_clickcell_brand"];
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

#pragma mark -UIColleciton View Datasource
- (void)p_reloadCollectionData
{
    BOOL isTable = self.isTableListStyle;
    NSString *btnTitle = isTable ? @"大图" : @"列表";
    self.rightBarBtn.title = btnTitle;
    if (_isHomeStyle) {
        [self.displayStyleBtn setTitle:btnTitle forState:UIControlStateNormal];
    }
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    }
    
    if (isTable) {
        [self wrapperCarBrandData];
//        self.collectionView.hidden = YES;
//        self.tableView.hidden = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView reloadData];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.alpha = 0;
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
//        self.collectionView.hidden = NO;
//        self.tableView.hidden = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.alpha = 1;
            self.tableView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _carBrandArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"carBrandCollectionCell" forIndexPath:indexPath];
    if (_carBrandArray.count > indexPath.row) {
        UIImageView *imageView = [cell viewWithTag:1];
        [imageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:_carBrandArray[indexPath.row].logo ?: @""] errorImage:[UIImage imageNamed:@"icon_car_brands"]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_carBrandArray.count > indexPath.row) {
        [MARDataAnalysis setEventPage:@"carBrandListVC" EventLabel:@"car_clickcell_brand"];
        MAACarBrandM *carBrandM = _carBrandArray[indexPath.row];
        [self performSegueWithIdentifier:@"goMAACarFactoryVC" sender:carBrandM];
    }
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    if (type == kMARNotificationType_NetworkChangedEnabel) {
        [self carBrandArray];
    }
}

@end
