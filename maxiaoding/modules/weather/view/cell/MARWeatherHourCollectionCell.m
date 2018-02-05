//
//  MARWeatherHourCollectionCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWeatherHourCollectionCell.h"
#import "MAAWeatherModel.h"
#import <UIImage+MAREX.h>
@interface MARWeatherHourCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation MARWeatherHourCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MAAWeatherHourInfoM class]]) {
        MAAWeatherHourInfoM *model = data;
        self.timeLabel.text = model.time;
        self.weatherImageView.image = [[UIImage imageNamed:[@"weather_" stringByAppendingString:model.img]] mar_imageByTintColor:MAAWeatherMainColor];
        self.tempLabel.text = model.temp;
    }
}

@end
