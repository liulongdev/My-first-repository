//
//  MARMonthDayView.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MARMonthDayView : UIControl

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) NSString *date;

@end

@interface MARMonthDayCollectionCell : UICollectionViewCell

- (void)setCellData:(id)data;

@end
