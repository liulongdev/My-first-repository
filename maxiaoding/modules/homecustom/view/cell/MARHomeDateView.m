//
//  MARHomeDateView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeDateView.h"
#import "MARAnalogClockView.h"
@interface MARHomeDateView() <MARAnalogClockDelegate>
@property (strong, nonatomic) IBOutlet UIView *dateTimeBackgroundView;
@property (strong, nonatomic) IBOutlet MARAnalogClockView *clockView;
- (IBAction)refreshTime:(id)sender;

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
    
    
    self.backgroundColor = RGBHEX(0x666666);
    self.clockView.enableShadows = YES;
    self.clockView.realTime = YES;
    self.clockView.currentTime = YES;
    self.clockView.borderColor = [UIColor whiteColor];
    self.clockView.borderWidth = 3;
    self.clockView.faceBackgroundColor = [UIColor whiteColor];
    self.clockView.faceBackgroundAlpha = 0.0;
//    self.clockView.delegate = self;
    self.clockView.digitFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.clockView.digitColor = [UIColor whiteColor];
    self.clockView.enableDigit = YES;
    self.clockView.secondHandLength = self.clockView.mar_height/2 - 10;
    
    
    [self.clockView startRealTime];
}

- (IBAction)refreshTime:(id)sender {
    [self.clockView setClockToCurrentTimeAnimated:YES];
}
@end
