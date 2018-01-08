//
//  MARWYCategoryTitleCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYCategoryTitleCell.h"

@interface MARWYCategoryTitleCell ()
@property (strong, nonatomic) IBOutlet MARLabel *titleLabel;

@end

@implementation MARWYCategoryTitleCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = nil;
    self.titleLabel.edgeInsets = UIEdgeInsetsMake(5, 8, 5, 8);
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = self.titleLabel.mar_height/2;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = RGBHEX(0xe0e0e0).CGColor;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.titleLabel.layer.borderColor = selected ? [UIColor blueColor].CGColor : RGBHEX(0xe0e0e0).CGColor;
    self.titleLabel.textColor = selected ? [UIColor blueColor] : RGBHEX(0x333333);
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.titleLabel.text = data;
    }
}

@end
