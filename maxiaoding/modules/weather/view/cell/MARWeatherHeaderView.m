//
//  MARWeatherHeaderView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWeatherHeaderView.h"
#import "MARWeatherHourCollectionCell.h"

@interface MARWeatherHeaderView () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIView *todayWeatherSimpleInfoView;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowlayout;

@end

@implementation MARWeatherHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MARWeatherHourCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MARWeatherHourCollectionCell"];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionFlowlayout.itemSize = CGSizeMake(40, 90);
    self.collectionFlowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)setWeatherModel:(MAAWeatherModel *)weatherModel
{
    _weatherModel = weatherModel;
    self.cityNameLabel.text = _weatherModel.city;
    self.weatherDescLabel.text = _weatherModel.weather;
    self.weekLabel.text = _weatherModel.week;
    self.lowTempLabel.text = _weatherModel.templow;
    self.highTempLabel.text = _weatherModel.temphigh;
    if (_weatherModel.hourly.count > 0) {
        self.tempLabel.text = [NSString stringWithFormat:@"%@º", _weatherModel.hourly[0].temp];
    }
    else
        self.tempLabel.text = nil;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.weatherModel.hourly.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARWeatherHourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MARWeatherHourCollectionCell" forIndexPath:indexPath];
    if (self.weatherModel.hourly.count > indexPath.row) {
        [cell setCellData:self.weatherModel.hourly[indexPath.row]];
    }
    return cell;
}

@end
