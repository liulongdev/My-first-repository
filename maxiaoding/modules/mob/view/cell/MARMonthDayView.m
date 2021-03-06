//
//  MARMonthDayView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARMonthDayView.h"
#import <Masonry.h>

@interface MARMonthDayView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL needDisplayDate;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation MARMonthDayView
@synthesize month = _month;
@synthesize day = _day;
- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.flowLayout.itemSize = self.frame.size;
}

- (void)setup
{
    [self addSubview:self.collectionView];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@(25));
    }];
//    self.leftLabel.frame = CGRectMake(0, 0, 25, self.mar_height);
    
    if (_month == 0 || _day == 0) {
        NSDate *date = [NSDate date];
        _month = [date mar_month];
        self.day = [date mar_day];
    }
}

- (void)scrollToDateWithAnimated:(BOOL)animated
{
    NSInteger daysIndex = (self.month == 1 ? 0 : ([[self _monthDaysArray][(self.month + 9) %11] integerValue])) + self.day - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:daysIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (NSInteger)month
{
    return MIN(12, MAX(1, _month));
}

- (NSInteger)day
{
    return MIN(31, MAX(1, _day));
}

- (void)setMonth:(NSInteger)month
{
    _month = month % 13;
//    [self setNeedDisplayDate:YES];
}

- (void)setDay:(NSInteger)day
{
    _day = day;
    if ([@[@(1),@(3),@(5),@(7),@(8),@(10), @(12)] containsObject:@(self.month)]) {
        if (day > 31) {
            self.month = self.month + 1;
            self.day = 1;
            return;
        }
    }
    else if ([@[@(4),@(6),@(9),@(11)] containsObject:@(self.month)])
    {
        if (day > 30) {
            self.month = self.month + 1;
            self.day = 1;
            return;
        }
    }
    else
    {
        if (day > 29) {
            self.month = self.month + 1;
            self.day = 1;
            return;
        }
    }
            
    [self setNeedDisplayDate:YES];
    [self scrollToDateWithAnimated:YES];
}


- (UICollectionView *)collectionView
{
    if ((!_collectionView)) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        [_collectionView registerClass:[MARMonthDayCollectionCell class] forCellWithReuseIdentifier:@"MARMonthDayCollectionCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.frame.size;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont systemFontOfSize:15.f];
        _leftLabel.userInteractionEnabled = YES;
        _leftLabel.text = @"<";
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor = RGBHEX(0x333333);
        _leftLabel.highlightedTextColor = RGBHEX(0xe0e0e0);
        @weakify(self)
        [_leftLabel mar_whenTapped:^{
            weak_self.day ++;
        }];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont systemFontOfSize:15.f];
        _rightLabel.userInteractionEnabled = YES;
        _rightLabel.text = @">";
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = RGBHEX(0x333333);
        _rightLabel.highlightedTextColor = RGBHEX(0xe0e0e0);
        @weakify(self)
        [_rightLabel mar_whenTapped:^{
            weak_self.day ++;
        }];
    }
    return _rightLabel;
}

#pragma mark - UICollection Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 1、3、5、7、8、10、12 三十一天， 4、6、9、11 三十天 2 二十九天
    return 7 * 31 + 4 * 30 + 29;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_needDisplayDate) {
        [self scrollToDateWithAnimated:NO];
        _needDisplayDate = NO;
    }
    MARMonthDayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MARMonthDayCollectionCell" forIndexPath:indexPath];
    __block NSString *monthDay = nil;
    [self _getMonthAndDayWithDaysIndex:indexPath.row callBack:^(NSInteger month, NSInteger day) {
        monthDay = [NSString stringWithFormat:@"%02ld-%02ld", (long)month, (long)day];
    }];
    [cell setCellData:monthDay];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self)
    [self _getMonthAndDayWithDaysIndex:indexPath.row callBack:^(NSInteger month, NSInteger day) {
        weak_self.month = month;
        weak_self.day = day;
    }];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)_totalDay
{
    //  1   2   3   4   5   6   7   8   9   10  11  12
    //  31  29  31  30  31  30  31  31  30  31  30  31
    // 1、3、5、7、8、10、12 三十一天， 4、6、9、11 三十天 2 二十九天
    return 7 * 31 + 4 * 30 + 29;
}

- (NSArray *)_monthDaysArray
{
    return @[@(31), @(60), @(91), @(121), @(152), @(182), @(213), @(243), @(274), @(305), @(335), @(366)];
}

- (void)_getMonthAndDayWithDaysIndex:(NSInteger)dayIndex callBack:(void (^)(NSInteger month, NSInteger day))monthDayCallBack
{
    if (monthDayCallBack) {
        NSInteger days = dayIndex + 1;
        if (days > [self _totalDay]) {
            days = days % [self _totalDay];
        }
        NSArray *monthDaysArray = [self _monthDaysArray];
        NSInteger month = 1;
        NSInteger day = 1;
        for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
            NSInteger dayCount = [monthDaysArray[monthIndex] integerValue];
            if (days <= dayCount) {
                month = monthIndex + 1;
                if (days <= [monthDaysArray[0] integerValue]) {
                    day = days;
                }
                else
                    day = days - [monthDaysArray[monthIndex - 1] integerValue];
                break;
            }
        }
        monthDayCallBack(month, day);
    }
}

- (NSInteger)_monthWithDaysIndex:(NSInteger)dayIndex
{
    NSInteger days = (dayIndex + 1) % [self _totalDay];
    NSArray *monthDaysArray = [self _monthDaysArray];
    int month = 1;
    for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
        if (days < [monthDaysArray[monthIndex] integerValue]) {
            month = monthIndex ++;
        }
    }
    return month;
}


@end

@interface MARMonthDayCollectionCell()
@property (nonatomic, strong) UILabel *monthDayLabel;
@end

@implementation MARMonthDayCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    [self.contentView addSubview:self.monthDayLabel];
    [self.monthDayLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UILabel *)monthDayLabel
{
    if (!_monthDayLabel) {
        _monthDayLabel = [UILabel new];
        _monthDayLabel.font = [UIFont systemFontOfSize:15];
        _monthDayLabel.adjustsFontSizeToFitWidth = YES;
        _monthDayLabel.textColor = RGBHEX(0x666666);
        _monthDayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthDayLabel;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.monthDayLabel.text = data;
    }
}

@end

