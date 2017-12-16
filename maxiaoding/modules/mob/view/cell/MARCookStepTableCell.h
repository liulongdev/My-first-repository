//
//  MARCookStepTableCell.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MARCookStepTableCell : UITableViewCell

- (void)setCellData:(id)data;

@property (nonatomic, copy) void (^loadAsyncImageCallback)(void);

@end
