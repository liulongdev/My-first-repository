//
//  MAACarDetailVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/5.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAACarDetailVC.h"
#import "MARALIAPINetworkManager.h"

@interface MAACarDetailVC () <UITableViewDataSource, UIScrollViewDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carSubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableHeaderViewWidth;
@property (weak, nonatomic) IBOutlet UIView *carSimpleInfoBackGoundView;
@property (weak, nonatomic) IBOutlet UIView *carSimpleInfoContainerView;
@property (weak, nonatomic) IBOutlet UIView *carImageBackGroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_carImageBackGroundViewWidth;

@property (nonatomic, strong) MAACarModel *carModel;

@end

@implementation MAACarDetailVC
{
    BOOL loadImageSuccess;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self carModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;  // 防止返回崩溃
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.tableFooterView = [UIView new];
    self.constraint_tableHeaderViewWidth.constant = kScreenWIDTH;
    
    self.view.backgroundColor = self.tableView.backgroundColor = RGBHEX(0xf4f4f4);
    
    self.carSimpleInfoBackGoundView.layer.shadowColor=[UIColor grayColor].CGColor;
    self.carSimpleInfoBackGoundView.layer.shadowOffset=CGSizeMake(5,5);
    self.carSimpleInfoBackGoundView.layer.shadowOpacity = 0.3;
    self.carSimpleInfoBackGoundView.layer.shadowRadius=5;
    self.carSimpleInfoContainerView.layer.masksToBounds = YES;
    self.carSimpleInfoContainerView.layer.cornerRadius = 10.f;
    
    self.carImageBackGroundView.layer.masksToBounds = YES;
    self.carImageBackGroundView.layer.cornerRadius = 10.f;
}

- (void)loadData
{
    @weakify(self);
    [self showActivityView:YES];
    [MARALIAPINetworkManager car_getCarDetailWithCarID:self.carId success:^(MAACarModel *carModel) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        strong_self.carModel = carModel;
        [strong_self _updateTableHeaderView];
        [strong_self.tableView reloadData];
        [carModel updateToDB];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [weak_self showActivityView:NO];
        NSLog(@">>>> error : %@", error);
    }];
}

- (MAACarModel *)carModel
{
    if (!_carModel) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _carModel = [MAACarModel carModelWithCarId:self.carId];
            mar_dispatch_async_on_main_queue(^{
                if (_carModel) {
                    [self _updateTableHeaderView];
                }
                else
                    [self loadData];
            });
        });
    }
    return _carModel;
}

- (void)_updateTableHeaderView
{
    NSURL *carImageURL = [NSURL URLWithString:_carModel.logo ?: @""];
    @weakify(self)
    [self.blurImageView sd_setImageWithURL:carImageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self)
        if (!strong_self) return;
        if (error) {
            strong_self.blurImageView.image = [[UIImage imageNamed:@"icon_car_brands"] mar_imageByBlurRadius:20 tintColor:RGBAHEX(MARColor_Main, 0.3) tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
            
            strong_self->loadImageSuccess = YES;
        }
        else if (image)
        {
            strong_self->loadImageSuccess = YES;
            strong_self.blurImageView.image = [image mar_imageByBlurRadius:20 tintColor:RGBAHEX(MARColor_Main, 0.3) tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
        }
    }];
    
    [self.carImageView mar_setImageDefaultCornerRadiusWithURL:carImageURL errorImage:[UIImage imageNamed:@"icon_car_brands"]];
    
    self.carNameLabel.text = [_carModel.fullname length] > 0 ? _carModel.fullname : _carModel.name;
    self.carSubNameLabel.text = _carModel.sizetype;
    
    self.carInfoLabel.attributedText = [[NSAttributedString alloc] initWithString:[_carModel.basic carInfoDescDispalyAll:NO] attributes:MARSTYLEFORMAT.shuoMingAttrDic];
    
    CGFloat height = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableHeaderView.mar_height = height;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableHeaderView.mar_height = height;
    self.tableView.tableHeaderView.mar_width = kScreenWIDTH;
    //    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_carModel) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_carModel) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carInfoTableCell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.attributedText = [self carInfoAttrStrWithIndex:indexPath.section];
    return cell;
}

- (NSAttributedString *)carInfoAttrStrWithIndex:(NSInteger)index
{
    NSAttributedString *attrStr = nil;
    if (index == 0) {
        // 车体
        attrStr = [[NSAttributedString alloc] initWithString:[_carModel.body carInfoDescDispalyAll:NO] attributes:MARSTYLEFORMAT.shuoMingAttrDic];
    }

    if (index == 1) {
        // 引擎
        attrStr = [[NSAttributedString alloc] initWithString:[_carModel.engine carInfoDescDispalyAll:NO] attributes:MARSTYLEFORMAT.shuoMingAttrDic];
    }
    return attrStr;
}

#pragma mark - UIScollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y + MARCONTENTINSETTOP(self);
    CGFloat maxPicWidth = kScreenWIDTH - 25 * 2;
    
    
    if (loadImageSuccess && offsetY < 0) {
        self.constraint_carImageBackGroundViewWidth.constant = MAX(150, MIN(maxPicWidth, 150 * (1 - offsetY / 150)));
    }
}

@end
