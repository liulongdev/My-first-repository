//
//  MARTitleCollectionReuableView.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/27.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARTitleCollectionReuableView.h"
@interface MARTitleCollectionReuableView()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MARTitleCollectionReuableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = nil;
}

- (void)setCellData:(id)data
{
    if ([data isKindOfClass:[NSString class]]) {
        self.titleLabel.text = data;
    }
}

@end
