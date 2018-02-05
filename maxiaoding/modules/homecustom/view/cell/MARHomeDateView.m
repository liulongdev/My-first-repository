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
@property (strong, nonatomic) IBOutlet MARAnalogClockView *clockView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_clockViewLELeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_clockViewWidth;
@property (strong, nonatomic) IBOutlet UILabel *calendarLabel;
@property (strong, nonatomic) IBOutlet UIImageView *animalImageView;

@property (nonatomic, strong) MARMobCalendarModel *calendarModel;
@end

@implementation MARHomeDateView
{
    BOOL zoomOutClockView;
}
+ (instancetype)nibView
{
    MARHomeDateView *view = [[[NSBundle mainBundle] loadNibNamed:@"MARHomeDateView" owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    zoomOutClockView = YES;
    [self configClockView];
    
    [self.clockView startRealTime];
    
    @weakify(self)
    [self.clockView mar_whenTapped:^{
        @strongify(self)
        strong_self->zoomOutClockView = !strong_self->zoomOutClockView;
        [strong_self configClockView];
    }];
    
    [self calendarModel];
}

- (void)configClockView
{
    [self.clockView reloadClock];
    if (zoomOutClockView) {
        self.constraint_clockViewLELeading.constant = 1000;
        self.constraint_clockViewWidth.constant = 180;
        self.clockView.enableShadows = YES;
        self.clockView.realTime = YES;
        self.clockView.currentTime = YES;
        self.clockView.borderColor = [UIColor whiteColor];
        self.clockView.borderWidth = 3;
        self.clockView.militaryTime = YES;
        self.clockView.faceBackgroundColor = [UIColor whiteColor];
        self.clockView.faceBackgroundAlpha = 0.0;
        //    self.clockView.delegate = self;
        self.clockView.enableGraduations = YES;
        self.clockView.enableDigit = YES;
        self.clockView.digitFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
        self.clockView.digitColor = [UIColor whiteColor];
        
        self.clockView.hourHandWidth = 3;
        self.clockView.minuteHandWidth = 3;
        self.clockView.secondHandWidth = 1;
    }
    else
    {
        self.constraint_clockViewLELeading.constant = 30;
        self.constraint_clockViewWidth.constant = 60;
        self.clockView.enableShadows = YES;
        self.clockView.realTime = YES;
        self.clockView.currentTime = YES;
        self.clockView.borderColor = [UIColor whiteColor];
        self.clockView.borderWidth = 1;
        self.clockView.militaryTime = YES;
        self.clockView.faceBackgroundColor = [UIColor whiteColor];
        self.clockView.faceBackgroundAlpha = 0.0;
        //    self.clockView.delegate = self;
        self.clockView.enableGraduations = NO;
        self.clockView.enableDigit = NO;
        self.clockView.hourHandWidth = 2;
        self.clockView.minuteHandWidth = 2;
        self.clockView.secondHandWidth = 0.5;
    }
    
    self.clockView.hourHandLength = (self.constraint_clockViewWidth.constant/2) / 2 * 2 / 3;
    self.clockView.hourHandOffsideLength = (self.constraint_clockViewWidth.constant/2) / 2 * 1 / 5;
    self.clockView.minuteHandLength = (self.constraint_clockViewWidth.constant/2) / 8 * 7 * 2 / 3;
    self.clockView.minuteHandOffsideLength = (self.constraint_clockViewWidth.constant/2) / 8 * 7 * 1 / 5;
    self.clockView.secondHandLength = self.constraint_clockViewWidth.constant/2 - 10;
    self.clockView.secondHandOffsideLength = self.constraint_clockViewWidth.constant/2 * 1 / 5;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (MARMobCalendarModel *)calendarModel
{
    if (!_calendarModel) {
        MARGLOBALMANAGER.dataFormatter.dateFormat = @"yyyy-MM-dd";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MARMobCalendarModel *calendar = [MARMobCalendarModel searchSingleWithWhere:@{@"date":[MARGLOBALMANAGER.dataFormatter stringFromDate:[NSDate new]] ?: @""} orderBy:nil];
            mar_dispatch_async_on_main_queue(^{
                if (calendar) {
                    _calendarModel = calendar;
                    [self setCalendarLabelDescription];
                }
                else
                    [self loadCalendarData];
            });
        });
    }
    return _calendarModel;
}


- (void)loadCalendarData
{
    @weakify(self)
    [MARMobUtil loadCalendarWithDate:[NSDate new] callback:^(MOBAResponse *response, MARMobCalendarModel *calendarModel, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        if (!response.error) {
            strong_self.calendarModel = calendarModel;
            [strong_self setCalendarLabelDescription];
        }
    }];
}

- (void)setCalendarLabelDescription
{
    if (_calendarModel) {
        self.calendarLabel.text = [_calendarModel description];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 10;
        style.alignment = NSTextAlignmentCenter;
        NSDate * now = [NSDate new];
        NSDictionary *monthDayAttrDic =@{NSParagraphStyleAttributeName: style,
                                         NSFontAttributeName: [UIFont boldSystemFontOfSize:40.f],
                                         NSForegroundColorAttributeName: RGBHEX(0x666666)
                                         };
        NSMutableAttributedString *monthDayAttr = [[NSMutableAttributedString alloc] init];
        [monthDayAttr appendAttributedString:[[NSAttributedString alloc] initWithString:MARSTRWITHINT(now.mar_month) attributes:monthDayAttrDic]];
        [monthDayAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@"月" attributes:@{NSParagraphStyleAttributeName: style, NSFontAttributeName: [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName: RGBHEX(0xffcc4d)}]];
        [monthDayAttr appendAttributedString:[[NSAttributedString alloc] initWithString:MARSTRWITHINT(now.mar_day) attributes:monthDayAttrDic]];
        [monthDayAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@"日" attributes:@{NSParagraphStyleAttributeName: style, NSFontAttributeName: [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName: RGBHEX(0xffcccc)}]];
        
//        NSAttributedString *monthDayAttr = [[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"%@月%@日", MARSTRWITHINT(now.mar_month), MARSTRWITHINT(now.mar_day)] attributes:monthDayAttrDic];
        
        NSString *tip = @"";
        if (_calendarModel.weekday.length > 0) {
            tip = [tip stringByAppendingFormat:@"\n%@", _calendarModel.weekday];
        }
        if (_calendarModel.lunar.length > 0) {
            tip = [tip stringByAppendingFormat:@"\n%@ %@", _calendarModel.lunarYear ?: @"", _calendarModel.lunar];
        }
        if (_calendarModel.holiday.length > 0) {
            tip = [tip stringByAppendingFormat:@"\n节日 : %@", _calendarModel.holiday];
        }
        if (_calendarModel.suit.length > 0) {
            tip = [tip stringByAppendingFormat:@"\n宜 : %@", _calendarModel.suit];
        }
        if (_calendarModel.avoid.length > 0) {
            tip = [tip stringByAppendingFormat:@"\n不宜／忌 : %@", _calendarModel.avoid];
        }
        if (_calendarModel.zodiac.length > 0) {
            tip = [tip stringByAppendingFormat:@"\n生肖: %@", _calendarModel.zodiac];
            UIImage *animalImage = [UIImage imageNamed:_calendarModel.zodiac];
            if (animalImage) {
                self.animalImageView.image = animalImage;
            }
        }
        
        NSAttributedString *tipAttr = [[NSAttributedString alloc] initWithString:tip attributes:MARSTYLEFORMAT.shuoMingCenterAttrDic];
        
        [attr appendAttributedString:monthDayAttr];
        [attr appendAttributedString:tipAttr];
        self.calendarLabel.attributedText = attr;
        
    }
}

- (void)refreshTime
{
    [self.clockView setClockToCurrentTimeAnimated:YES];
}

@end
