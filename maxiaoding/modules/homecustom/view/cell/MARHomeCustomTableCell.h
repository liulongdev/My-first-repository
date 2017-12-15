//
//  MARHomeCustomTableCell.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MARHomeCustomTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *marContentView;

@property (nonatomic, copy) void (^bottomAppearBlock)(void);

@property (nonatomic, copy) void (^topAppearBlock)(void);

@end
