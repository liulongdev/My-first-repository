//
//  MARCookCategoryCollectionVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/26.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCookCategoryCollectionVC.h"
#import "MARCookCategoryCollecitonCell.h"
#import "MARSearchCookVC.h"
#import "MARTitleCollectionReuableView.h"

@interface MARCookCategoryCollectionVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<MARCookCategoryMenuModel *> *cookCategoryMenuArray;

@property (nonatomic, strong) NSMutableDictionary *hiddenMenuDic;

@end

@implementation MARCookCategoryCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cookCategoryMenuArray];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MARTitleCollectionReuableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MARTitleCollectionReuableView"];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.collectionView, self);
    if (self.isSelectStyle) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goSearchCookVC:)];
    }
}

- (NSArray<MARCookCategoryMenuModel *> *)cookCategoryMenuArray {
    if (!_cookCategoryMenuArray) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _cookCategoryMenuArray = (NSArray<MARCookCategoryMenuModel *> *)[MARCookCategoryMenuModel mar_getAllDBModelArray];
            if (_cookCategoryMenuArray.count > 0) {
                mar_dispatch_async_on_main_queue(^{
                    [self.collectionView reloadData];
                    [self scrollViewToSelectCell];
                });
            }
            else
            {
                [self loadData];
            }
        });
    }
    return _cookCategoryMenuArray;
}

- (NSMutableDictionary *)hiddenMenuDic
{
    if (!_hiddenMenuDic) {
        _hiddenMenuDic = [NSMutableDictionary dictionaryWithCapacity:1 << 4];
    }
    return _hiddenMenuDic;
}

- (void)scrollViewToSelectCell
{
    if (self.selectCookCategory && self.isSelectStyle) {
        for (int section = 0; section < _cookCategoryMenuArray.count; section ++) {
            NSInteger index = [_cookCategoryMenuArray[section].childs indexOfObject:self.selectCookCategory];
            if (index != NSNotFound) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            }
        }
    }
}

- (void)loadData
{
    @weakify(self)
    [MARMobUtil loadCookCategoriesCallback:^(MOBAResponse *response, NSArray<MARCookCategoryMenuModel *> *cookCategoryMenuArray, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        if (!response.error) {
            strong_self->_cookCategoryMenuArray = cookCategoryMenuArray;
            [strong_self.collectionView reloadData];
            if (cookCategoryMenuArray.count > 0) {
                [strong_self hiddenEmptyView];
            }
            else
            {
                [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
            }
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
            [strong_self showEmptyViewWithDescription:@"我的腹中空空如也～"];
        }
    }];
}

- (void)goSearchCookVC:(id)sender
{
    [self performSegueWithIdentifier:@"goSearchCookVC" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIColleciton datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _cookCategoryMenuArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MARTitleCollectionReuableView" forIndexPath:indexPath];
        if (_cookCategoryMenuArray.count > indexPath.section) {
            if ([reusableView isKindOfClass:[MARTitleCollectionReuableView class]]) {
                MARTitleCollectionReuableView *titleView = (MARTitleCollectionReuableView *)reusableView;
                MARCookCategoryMenuModel *model = _cookCategoryMenuArray[indexPath.section];
                [titleView setCellData:model.name];
                titleView.showOrHiddenBtn.selected = [self.hiddenMenuDic[MARSTRWITHINT(indexPath.section)] boolValue];
                [titleView.showOrHiddenBtn mar_removeAllActionBlocks];
                @weakify(self)
                [titleView.showOrHiddenBtn mar_addActionBlock:^(id sender) {
                    titleView.showOrHiddenBtn.selected = !titleView.showOrHiddenBtn.selected;
                    [weak_self.hiddenMenuDic setObject:@(titleView.showOrHiddenBtn.selected) forKey:MARSTRWITHINT(indexPath.section)];
                    [weak_self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                } forState:UIControlEventTouchUpInside];
            }
        }
    }
    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_cookCategoryMenuArray.count > section) {
        if (![self.hiddenMenuDic[MARSTRWITHINT(section)] boolValue]) {
            return _cookCategoryMenuArray[section].childs.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MARCookCategoryCollecitonCell *cookCategoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MARCookCategoryCollecitonCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (_cookCategoryMenuArray.count > indexPath.section) {
        if (_cookCategoryMenuArray[indexPath.section].childs.count > row) {
            MARCookCategoryModel *cookCategory = _cookCategoryMenuArray[indexPath.section].childs[row];
            [cookCategoryCell setCellData:cookCategory.name];
            [cookCategoryCell mar_setSelected:[cookCategory isEqual:self.selectCookCategory]];
        }
    }
    return cookCategoryCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_cookCategoryMenuArray.count > indexPath.section) {
        if (_cookCategoryMenuArray[indexPath.section].childs.count > row) {
            MARCookCategoryModel *model = _cookCategoryMenuArray[indexPath.section].childs[row];
            // 选择模式
            if (self.isSelectStyle) {
                if ([model isEqual:self.selectCookCategory]) {
                    self.selectCookCategory = nil;
                }
                else
                    self.selectCookCategory = model;
                if (self.selectedCallback) {
                    self.selectedCallback(self.selectCookCategory);
                }
                [self.collectionView reloadData];
            }
            else
            {
                [self performSegueWithIdentifier:@"goSearchCookVC" sender:model];
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goSearchCookVC"]) {
        MARSearchCookVC *searchCookVC = segue.destinationViewController;
        if ([searchCookVC isKindOfClass:[MARSearchCookVC class]]) {
            if ([sender isKindOfClass:[MARCookCategoryModel class]]) {
                searchCookVC.cookCategoryModel = sender;
            }
        }
    }
}

@end
