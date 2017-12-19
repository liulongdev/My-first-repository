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
    self.title = @"微信精选";
    [self wxArticleArray];
    MARAdjustsScrollViewInsets_NO(self.collectionView, self);
}

- (void)loadData
{
//    if (_wxArticleArray.count > 0) {
//        return;
//    }
    @weakify(self)
    [self showActivityView:YES];
    [MARMobUtil loadWXArticleCategoryCallback:^(MOBAResponse *response, NSArray<MARWXArticleCategoryModel *> *articleArray, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        if (!response.error) {
            strong_self->_wxArticleArray = articleArray;
            [strong_self.collectionView reloadData];
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
            NSLog(@">>> getVerifyCode error : %@", errMsg ?: [response.error localizedDescription]);
        }
    }];
    
}

- (NSArray<MARWXArticleCategoryModel *> *)wxArticleArray
{
    if (!_wxArticleArray) {
        static BOOL simpleAsync = NO;
        [self showActivityView:YES]; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!simpleAsync) {
                simpleAsync = YES;
                self.wxArticleArray = (NSArray<MARWXArticleCategoryModel *> *)[MARWXArticleCategoryModel mar_getAllDBModelArray];
                if (_wxArticleArray.count <= 0) {
                    [self loadData];
                }
                else
                {
                    mar_dispatch_async_on_main_queue(^{
                        [self showActivityView:NO];
                        [self.collectionView reloadData];
                    });
                }
                simpleAsync = NO;
            }
        });
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
    return _wxArticleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARWXArticleCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MARWXArticleCategoryCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (_wxArticleArray.count > row) {
        [cell setCellData:_wxArticleArray[row].name];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_wxArticleArray.count > row) {
        CGSize labelSize = [_wxArticleArray[row].name mar_sizeForFont:[UIFont systemFontOfSize:20.f] size:CGSizeMake(kScreenWidth, FLT_MAX) mode:NSLineBreakByWordWrapping];
        return CGSizeMake(labelSize.width + 16, labelSize.height + 16);
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_wxArticleArray.count > row) {
        [self performSegueWithIdentifier:@"goArticleListVC" sender:_wxArticleArray[row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MARWXArticelListVC *vc = segue.destinationViewController;
    MARWXArticleCategoryModel *model = sender;
    if ([vc isKindOfClass:[MARWXArticelListVC class]] && [model isKindOfClass:[MARWXArticleCategoryModel class]]) {
        vc.cid = model.cid;
        vc.title = model.name;
    }
}

@end
