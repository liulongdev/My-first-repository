//
//  MARCookCategoryCollecitonCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/26.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookCategoryCollecitonCell.h"

@interface MARCookCategoryCollecitonCell()
@property (strong, nonatomic) IBOutlet MARLabel *cookCategoryTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation MARCookCategoryCollecitonCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cookCategoryTitleLabel.text = nil;
    self.cookCategoryTitleLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.cookCategoryTitleLabel.layer.masksToBounds = YES;
    self.cookCategoryTitleLabel.layer.cornerRadius = 6;
    self.cookCategoryTitleLabel.layer.borderWidth = 1;
    self.cookCategoryTitleLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.cookCategoryTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.checkImageView.hidden = YES;
    self.checkImageView.image = [[UIImage imageNamed:@"icon_check_selected"] mar_imageByTintColor:[UIColor blueColor]];
}

- (void)mar_setSelected:(BOOL)selected
{
    self.checkImageView.hidden = !selected;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.cookCategoryTitleLabel.text = data;
    }
}

@end
