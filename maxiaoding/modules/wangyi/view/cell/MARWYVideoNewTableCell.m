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
@interface MARWYVideoNewTableCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *sourceImageView;
@property (strong, nonatomic) IBOutlet UILabel *sourceNameLabel;

@end

@implementation MARWYVideoNewTableCell

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
    if ([data isKindOfClass:[MARWYVideoNewModel class]]) {
        MARWYVideoNewModel *model = data;
        self.titleLabel.text = model.title;
        [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover ?: @""] placeholderImage:[UIImage imageNamed:@"img_media_default"]];
        self.sourceNameLabel.text = model.topicName;
        [self.sourceImageView sd_setImageWithURL:[NSURL URLWithString:model.cover ?: @""] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
//        [self.sourceImageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:model.topicImg ?: @""] placeholderImage:nil];
    }
}

- (void)addPlayerView:(MARWYVideoPlayView *)playView
{
    if (!playView) return;
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
