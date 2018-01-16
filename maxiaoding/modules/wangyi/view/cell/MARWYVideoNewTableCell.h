//
//  MARWYVideoNewTableCell.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MARWYVideoPlayView.h"
@interface MARWYVideoNewTableCell : UITableViewCell
@property (nonatomic, weak) MARWYVideoPlayView *playView;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *collecionBtn;


- (void)addPlayerView:(MARWYVideoPlayView *)playView;
- (void)setCellData:(id)data;

@end
