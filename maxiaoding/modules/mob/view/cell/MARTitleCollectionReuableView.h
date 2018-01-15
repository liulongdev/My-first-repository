//
//  MARTitleCollectionReuableView.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/27.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MARTitleCollectionReuableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *showOrHiddenBtn;

- (void)setCellData:(id)data;

@end
