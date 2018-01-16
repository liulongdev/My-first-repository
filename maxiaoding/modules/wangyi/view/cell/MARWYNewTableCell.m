//
//  MARWYNewTableCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewTableCell.h"
#import "UIImageView+SDWEBEXT.h"
#import "MARWYUtility.h"
#import <NSObject+MARModel.h>
@interface MARWYNewTableCell ()
@property (strong, nonatomic) IBOutlet UIImageView *wyImageView;
@property (strong, nonatomic) IBOutlet UILabel *wyTitleLabel;
@property (strong, nonatomic) IBOutlet MARLabel *wySourceLabel;
@property (strong, nonatomic) IBOutlet MARLabel *wyCommentCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *videoFlagImageView;

@end

@implementation MARWYNewTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoFlagImageView.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MARWYNewModel class]]) {
        MARWYNewModel *model = data;
        [self.wyImageView mar_setImageDefaultCornerRadiusWithURL:[NSURL URLWithString:model.imgsrc ?: @""] placeholderImage:nil];
        self.wyTitleLabel.text = model.title;
        self.wySourceLabel.text = model.source;
        self.wyCommentCountLabel.text = [NSString stringWithFormat:@"%@  %@回帖", model.ptime.length > 0 ? [MARUTILITY briefTimeStrWithDateStr:model.ptime] : @"", MARSTRWITHINT(model.replyCount)];
        if ([model.skipType isEqualToString:WYNEWSkipType_Video]) {
            self.videoFlagImageView.hidden = NO;
        }
        else
        {
           self.videoFlagImageView.hidden = YES;
        }
    }
}

@end
