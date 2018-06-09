//
//  MARWYPhotoBrowserCell.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/9.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYPhotoBrowserCell.h"
#import "MARWYNewModel.h"
#import "UIImageView+SDWEBEXT.h"

@interface MARWYPhotoBrowserCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation MARWYPhotoBrowserCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setData:(id)data
{
    if ([data isKindOfClass:[MARWYPhotoNewPhotoDetialModel class]]) {
        MARWYPhotoNewPhotoDetialModel *model = data;
        [self.imageView setShowActivityIndicatorView:YES];
        [self.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl]];
    }
}

- (IBAction)clickLeftBtnAction:(id)sender {
    UICollectionView *collectionView = [self currentCollectionView];
    if (collectionView) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:self];
        if (indexPath.row > 0) {
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}

- (IBAction)clickRightBtnAction:(id)sender {
    UICollectionView *collectionView = [self currentCollectionView];
    if (collectionView) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:self];
        NSInteger count = [collectionView numberOfItemsInSection:0];
        if (indexPath.row + 1 < count) {
            [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}

- (id)currentCollectionView
{
    UIView *superview = self.superview;
    while (superview && ![superview isKindOfClass:[UICollectionView class]]) {
        superview = superview.superview;
    }
    return superview;
}

@end
