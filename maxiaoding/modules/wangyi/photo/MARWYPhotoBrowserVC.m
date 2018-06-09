//
//  MARWYPhotoBrowserVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/9.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYPhotoBrowserVC.h"
#import "MARWYPhotoBrowserCell.h"
#import <Masonry.h>
@interface MARWYPhotoBrowserVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowlayout;
@property (strong, nonatomic) IBOutlet UILabel *pageIndexLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *photoDescLabel;

@property (nonatomic, strong) NSArray<MARWYPhotoNewPhotoDetialModel *> *photoArray;

- (IBAction)clickBackBtnAction:(id)sender;

@end

@implementation MARWYPhotoBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView reloadData];
}

- (void)UIGlobal
{
    if (self.navigationController && !self.navigationController.navigationBar.isHidden) {
        self.backBtn.hidden = YES;
    }
    self.flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat height = kScreenHEIGHT - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.mar_height - MARiPhoneX_BottomMargin;
    self.flowlayout.itemSize = CGSizeMake(kScreenWIDTH, height);
    
    if (self.backgroundImage) {
        self.collectionView.backgroundColor = [UIColor clearColor];
        UIImageView *backgroundImageView = [UIImageView new];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        backgroundImageView.image = self.backgroundImage;
        [self.view addSubview:backgroundImageView];
        [self.view sendSubviewToBack:backgroundImageView];
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottomLayoutGuideBottom);
            make.leading.mas_equalTo(self.view);
            make.trailing.mas_equalTo(self.view);
            make.top.mas_equalTo(self.mas_topLayoutGuideTop);
        }];
    }
}

- (void)setPhotoNewModel:(MARWYPhotoNewModel *)photoNewModel
{
    _photoNewModel = photoNewModel;
    self.photoArray = _photoNewModel.photos;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARWYPhotoBrowserCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"photoCellIdentifier" forIndexPath:indexPath];
    if (self.photoArray.count > indexPath.row) {
        [cell setData:self.photoArray[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * currentIndexPath = [self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + 20, 0)];
    NSInteger row = currentIndexPath.row;
    if (self.photoArray.count > row) {
        [self setPhotoDesc:self.photoArray[row].note];
    }
    self.pageIndexLabel.text = [NSString stringWithFormat:@"%@/%@", MARSTRWITHINT(row + 1), MARSTRWITHINT(self.photoArray.count)];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.photoArray.count > row) {
        [self setPhotoDesc:self.photoArray[row].note];
    }
    self.pageIndexLabel.text = [NSString stringWithFormat:@"%@/%@", MARSTRWITHINT(row + 1), MARSTRWITHINT(self.photoArray.count)];
}

- (void)setPhotoDesc:(NSString *)photoDesc
{
    if (photoDesc.length == 0) {
        self.bottomView.hidden = YES;
    }
    else
    {
        self.photoDescLabel.text = photoDesc;
    }
}

- (IBAction)clickBackBtnAction:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
