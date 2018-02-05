//
//  MARWeatherDayCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/2.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWeatherDayCell.h"
#import "MAAWeatherModel.h"
#import <UIImage+MAREX.h>
@interface MARWeatherDayCell ()
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nightWeatherImageView;

@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *highTempLabel;

@end

@implementation MARWeatherDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MAAWeatherDayInfoM class]]) {
        MAAWeatherDayInfoM *model = data;
        self.weekDayLabel.text = model.week;
        self.weatherImageView.image = [[UIImage imageNamed:[@"weather_" stringByAppendingString:model.day.img]] mar_imageByTintColor:MAAWeatherMainColor];
        self.nightWeatherImageView.image = [[UIImage imageNamed:[@"weather_" stringByAppendingString:model.night.img]] mar_imageByTintColor:MAAWeatherMainColor];
        self.lowTempLabel.text = model.night.templow;
        self.highTempLabel.text = model.day.temphigh;
    }
}

@end
