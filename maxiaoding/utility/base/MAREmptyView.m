//
//  MAREmptyView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/20.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MAREmptyView.h"
#import <Masonry.h>
@interface MAREmptyView()

@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyDescriptionLabel;

@end

@implementation MAREmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)setup
{
    [self addSubview:self.emptyImageView];
    [self addSubview:self.emptyDescriptionLabel];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.leading.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
    }];
    
    [self.emptyDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).mas_offset(@(15));
        make.leading.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
    }];
    
    
    [self.emptyDescriptionLabel setContentHuggingPriority:UILayoutPriorityDefaultLow - 5 forAxis:UILayoutConstraintAxisVertical];
    
}

- (UILabel *)emptyDescriptionLabel
{
    if (!_emptyDescriptionLabel) {
        _emptyDescriptionLabel = [UILabel new];
        _emptyDescriptionLabel.numberOfLines = 5;
        _emptyDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyDescriptionLabel;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = [UIImageView new];
        _emptyImageView.image = [UIImage imageNamed:@"img_loaddata_failure"];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _emptyImageView;
}

- (void)setEmptyImage:(UIImage *)emptyImage
{
    _emptyImage = emptyImage;
    _emptyImageView.image = emptyImage;
    if (emptyImage) {
        [self.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_lessThanOrEqualTo(self);
        }];
    }
    else
    {
        if(self.emptyImageView.superview)
        {
            [self.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_lessThanOrEqualTo(@(0));
            }];
        }
    }
}

- (void)setEmptyDescription:(NSString *)emptyDescription
{
    _emptyDescription = emptyDescription;
    self.emptyDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:_emptyDescription ?: @"" attributes:MARSTYLEFORMAT.shuoMingCenterAttrDic];
}

@end
