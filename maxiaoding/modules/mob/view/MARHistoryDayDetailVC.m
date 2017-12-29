//
//  MARHistoryDayDetailVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHistoryDayDetailVC.h"

@interface MARHistoryDayDetailVC ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) NSDictionary *attrDic;
@end

@implementation MARHistoryDayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MARAdjustsScrollViewInsets_NO(self.scrollView, self);
    self.title = self.historyDayModel.title;
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:self.historyDayModel.event ?: @"" attributes:self.attrDic];
}

- (NSDictionary *)attrDic
{
    if (!_attrDic) {
        NSMutableParagraphStyle *style = style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 8;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _attrDic = @{NSParagraphStyleAttributeName: style,
                     NSFontAttributeName: MAREXTFont(18.f),
                     NSForegroundColorAttributeName: RGBHEX(0x333333)
                     };
    }
    return _attrDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
