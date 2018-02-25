//
//  MARWYVideoNewTableCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYVideoNewTableCell.h"
#import "MARWYNewModel.h"
#import "UIImageView+SDWEBEXT.h"
#import <Masonry.h>
#import <MARLabel.h>
@interface MARWYVideoNewTableCell()

@property (strong, nonatomic) IBOutlet MARLabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sourceImageView;
@property (strong, nonatomic) IBOutlet UILabel *sourceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@end

@implementation MARWYVideoNewTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collecionBtn.layer.masksToBounds = YES;
    self.collecionBtn.layer.borderWidth = 1;
    self.collecionBtn.layer.borderColor = RGBHEX(0x999999).CGColor;
    self.collecionBtn.layer.cornerRadius = 8;
    
    self.titleLabel.edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.titleLabel.backgroundColor = UIColorFromRGB(0x000000, 0.3);
    self.titleLabel.preferredMaxLayoutWidth = kScreenWIDTH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MARWYVideoNewModel class]]) {
        MARWYVideoNewModel *model = data;
        self.titleLabel.text = model.title;
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover ?: @""] placeholderImage:[UIImage imageNamed:@"img_media_default"]];
        self.sourceNameLabel.text = model.topicName;
        [self.sourceImageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:model.topicImg ?: @""] errorImage:[UIImage imageNamed:@"img_loaddata_failure"]];
        NSInteger dMin = model.length / 60;
        NSInteger dSec = model.length % 60;
        self.videoTimeLengthLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
        if ([model.ptime mar_stringByTrim].length > 0 && [model.ptime rangeOfString:@" "].location == NSNotFound) {
            MARGLOBALMANAGER.dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.publishTimeLabel.text = [MARGLOBALMANAGER.dataFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.ptime integerValue]/1000]];
        }
        else
            self.publishTimeLabel.text = model.ptime;
//        [self.sourceImageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:model.topicImg ?: @""]];
    }
}

- (void)addPlayerView:(MARWYVideoPlayView *)playView
{
    [_playView removeFromSuperview];
    _playView = nil;
    self.playView = playView;
    [self addSubview:playView];
    [self.playView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoImageView);
        make.leading.mas_equalTo(self.videoImageView);
        make.bottom.mas_equalTo(self.videoImageView);
        make.trailing.mas_equalTo(self.videoImageView);
    }];
    
}

@end
