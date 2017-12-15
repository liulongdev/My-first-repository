//
//  MARHomeDateView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeDateView.h"

@interface MARHomeDateView()
@property (strong, nonatomic) IBOutlet UIView *dateTimeBackgroundView;

@end

@implementation MARHomeDateView

+ (instancetype)nibView
{
    MARHomeDateView *view = [[[NSBundle mainBundle] loadNibNamed:@"MARHomeDateView" owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateTimeBackgroundView.layer.masksToBounds = YES;
    self.dateTimeBackgroundView.layer.cornerRadius = self.dateTimeBackgroundView.mar_height/2;
    self.dateTimeBackgroundView.layer.borderColor = RGBHEX(0x999999).CGColor;
    self.dateTimeBackgroundView.layer.borderWidth = 2 * [UIScreen mainScreen].scale;
}

@end
