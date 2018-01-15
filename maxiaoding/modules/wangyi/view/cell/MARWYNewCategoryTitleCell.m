//
//  MARWYNewCategoryTitleCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/12.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewCategoryTitleCell.h"

@interface MARWYNewCategoryTitleCell ()
@property (weak, nonatomic) IBOutlet MARLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeLabel;

@end

@implementation MARWYNewCategoryTitleCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.titleLabel = [aDecoder decodeObjectForKey:@"mxd_titleLabel"];
    self.closeLabel = [aDecoder decodeObjectForKey:@"mxd_closeLabel"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.titleLabel forKey:@"mxd_titleLabel"];
    [aCoder encodeObject:self.closeLabel forKey:@"mxd_closeLabel"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.text = nil;
    self.titleLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 6;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.closeLabel.hidden = YES;
    self.closeLabel.layer.masksToBounds = YES;
    self.closeLabel.layer.cornerRadius = self.closeLabel.mar_height / 2;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.titleLabel.text = data;
    }
}

- (void)setEditStyle:(MARWYNewCategoryCellStyle)style
{
    self.titleLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 6;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.alpha = 1;
    self.closeLabel.hidden = YES;
    if (style == MARWYNewCategoryCellStyleNone) {
        self.titleLabel.alpha = 1;
        self.closeLabel.hidden = YES;
    }
    else
    {
        if (style == MARWYNewCategoryCellStyleMoving)
        {
            self.titleLabel.alpha = 0.5;
        }
        if (style == MARWYNewCategoryCellStyleEdit) {
            self.closeLabel.hidden = NO;
        }
    }
        
}

@end
