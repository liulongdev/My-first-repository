//
//  MARWXArticleCell.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MARWXArticleCategoryCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *marTitleLabel;

- (void)setCellData:(id)data;

@end
