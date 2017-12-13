//
//  MARWXArticelListVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWXArticleCategoryVC.h"
#import "MARWXArticleCategoryCell.h"
#import <MobAPI/MobAPI.h>
#import "MARWXArticelListVC.h"

@interface MARWXArticleCategoryVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<MARWXArticleCategoryModel *> *wxArticleArray;
@end

@implementation MARWXArticleCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
//    if (self.wxArticleArray.count > 0) {
//        return;
//    }
    __weak __typeof(self) weakSelf = self;
    [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleCategoryRequest] onResult:^(MOBAResponse *response) {
        if (!response.error) {
            NSArray<MARWXArticleCategoryModel *> *articleArray = [NSArray mar_modelArrayWithClass:[MARWXArticleCategoryModel class] json:response.responder[@"result"]];
            weakSelf.wxArticleArray = articleArray;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARWXArticleCategoryModel *model in articleArray) {
                    [model updateToDB];
                }
            });
            [weakSelf.collectionView reloadData];
        }
    }];
}

- (NSArray<MARWXArticleCategoryModel *> *)wxArticleArray
{
    if (!_wxArticleArray) {
        _wxArticleArray = (NSArray<MARWXArticleCategoryModel *> *)[MARWXArticleCategoryModel mar_getAllDBModelArray];
    }
    return _wxArticleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.wxArticleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARWXArticleCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MARWXArticleCategoryCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (self.wxArticleArray.count > row) {
        [cell setCellData:self.wxArticleArray[row].name];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.wxArticleArray.count > row) {
        CGSize labelSize = [self.wxArticleArray[row].name mar_sizeForFont:[UIFont systemFontOfSize:20.f] size:CGSizeMake(kScreenWidth, FLT_MAX) mode:NSLineBreakByWordWrapping];
        return CGSizeMake(labelSize.width + 16, labelSize.height + 16);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (self.wxArticleArray.count > row) {
        [self performSegueWithIdentifier:@"goArticleListVC" sender:self.wxArticleArray[row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MARWXArticelListVC *vc = segue.destinationViewController;
    MARWXArticleCategoryModel *model = sender;
    if ([vc isKindOfClass:[MARWXArticelListVC class]] && [model isKindOfClass:[MARWXArticleCategoryModel class]]) {
        vc.cid = model.cid;
    }
}

@end
