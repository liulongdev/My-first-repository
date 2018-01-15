//
//  MARWYNewCategoryTitleCell.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/12.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MARWYNewCategoryCellStyle) {
    MARWYNewCategoryCellStyleNone,
    MARWYNewCategoryCellStyleMoving = 1,
    MARWYNewCategoryCellStyleEdit = 2,
};

@interface MARWYNewCategoryTitleCell : UICollectionViewCell

- (void)setCellData:(id)data;

- (void)setEditStyle:(MARWYNewCategoryCellStyle)style;

@end
