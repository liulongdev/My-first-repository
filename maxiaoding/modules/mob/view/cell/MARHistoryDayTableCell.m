//
//  MARHistoryDayTableCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHistoryDayTableCell.h"

@interface MARHistoryDayTableCell()
@property (strong, nonatomic) IBOutlet UILabel *marTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *marTimeLabel;

@end

@implementation MARHistoryDayTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[MARHistoryDayModel class]]) {
        MARHistoryDayModel *model = data;
        self.marTitleLabel.text = model.title;
        self.marTimeLabel.text = [model getDateStr];
    }
}

@end
