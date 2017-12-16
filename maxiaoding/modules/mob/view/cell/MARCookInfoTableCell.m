//
//  MARCookInfoTableCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookInfoTableCell.h"
#import <UIImageView+WebCache.h>
@interface MARCookInfoTableCell()
@property (strong, nonatomic) IBOutlet UIImageView *cookImageView;
@property (strong, nonatomic) IBOutlet UILabel *cookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookCategoriesLabel;

@end

@implementation MARCookInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MARCookDetailModel class]]) {
        MARCookDetailModel *model = data;
        
        // 对第一次下载下来的图片进行圆弧剪切，并保存。 所以每次去找缓存、硬盘中找是否有，如果有就使用，不用再去做多余的圆弧剪切功能。
        NSURL *imageURL = [NSURL URLWithString:model.thumbnail ?: @""];
        [self.cookImageView mar_setImageDefaultCornerRadiusWithURL:imageURL placeholderImage:nil];
        
        self.cookNameLabel.text = model.name;
        self.cookCategoriesLabel.text = model.ctgTitles;
    }
}

@end
