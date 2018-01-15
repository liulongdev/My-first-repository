//
//  MARWYChooseNewCategoryVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYChooseNewCategoryVC.h"
#import "MARWYNewCategoryTitleCell.h"

@interface MARWYChooseNewCategoryVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<MARWYNewCategoryTitleModel *> *favoriteTitleArray;

@property (nonatomic, strong) NSMutableArray<MARWYNewCategoryTitleModel *> *recommendTitleArray;

@property (nonatomic,strong)NSMutableArray *cellAttributesArray;
@property (nonatomic,assign)BOOL isChange;
@property (nonatomic, strong) MARWYNewCategoryTitleCell *movingCell;
@property (nonatomic, strong) NSIndexPath *movingIndexPath;

@property (nonatomic, strong) UIBarButtonItem *editRightItem;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isEditingCell;
@end

@implementation MARWYChooseNewCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isEditingCell = NO;
    self.longPressGesture.enabled = NO;
    [self.collectionView addGestureRecognizer:self.longPressGesture];
    self.navigationItem.rightBarButtonItem = self.editRightItem;
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.collectionView, self);
}

- (NSMutableArray<MARWYNewCategoryTitleModel *> *)recommendTitleArray
{
    if (!_recommendTitleArray) {
        NSArray *categoryTitleModelArray = (NSArray<MARWYNewCategoryTitleModel *> *)[MARWYNewCategoryTitleModel getArrayFavorite:NO];
        _recommendTitleArray = [NSMutableArray arrayWithArray:categoryTitleModelArray];
    }
    return _recommendTitleArray;
}

- (NSMutableArray<MARWYNewCategoryTitleModel *> *)favoriteTitleArray
{
    if (!_favoriteTitleArray) {
        NSArray *categoryTitleModelArray = (NSArray<MARWYNewCategoryTitleModel *> *)[MARWYNewCategoryTitleModel getArrayFavorite:YES];
        _favoriteTitleArray = [NSMutableArray arrayWithArray:categoryTitleModelArray];
    }
    return _favoriteTitleArray;
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    }
    return _longPressGesture;
}

-(UIBarButtonItem *)editRightItem
{
    if (!_editRightItem) {
        _editRightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightItemAction:)];
    }
    return _editRightItem;
}

- (void)setIsEditingCell:(BOOL)isEditingCell
{
    _isEditingCell = isEditingCell;
    [self.collectionView reloadData];
}

- (void)clickRightItemAction:(UIBarButtonItem *)item
{
    if ([self.editRightItem.title isEqualToString:@"编辑"]) {
        self.isEditingCell = YES;
        self.longPressGesture.enabled = YES;
        self.editRightItem.title = @"完成";
    }
    else
    {
        self.isEditingCell = NO;
        self.longPressGesture.enabled = NO;
        for (int i = 0; i < self.favoriteTitleArray.count; i++) {
            MARWYNewCategoryTitleModel *titleModel = self.favoriteTitleArray[i];
            titleModel.notAttention = NO;
            titleModel.orderNumber = i;
            [titleModel updateToDB];
        }
        for (int i = 0; i < self.recommendTitleArray.count; i++) {
            MARWYNewCategoryTitleModel *titleModel = self.recommendTitleArray[i];
            titleModel.notAttention = YES;
            titleModel.orderNumber = i;
            [titleModel updateToDB];
        }
        ShowSuccessMessage(@"编辑成功", 1.5f);
        if (self.FinishOrChooseBlock) {
            self.FinishOrChooseBlock(self.favoriteTitleArray, nil);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.recommendTitleArray.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? self.favoriteTitleArray.count : self.recommendTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray<MARWYNewCategoryTitleModel *> *titleModelArray = indexPath.section == 0 ? self.favoriteTitleArray : self.recommendTitleArray;
    MARWYNewCategoryTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MARWYNewCategoryTitleCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (titleModelArray.count > row) {
        [cell setCellData:titleModelArray[row].tname];
    }
    
    [cell setEditStyle:MARWYNewCategoryCellStyleNone];
    if (self.movingIndexPath && [indexPath isEqual:self.movingIndexPath]) {
        [cell setEditStyle:MARWYNewCategoryCellStyleMoving];
    }
    if (_isEditingCell) {
        [cell setEditStyle:MARWYNewCategoryCellStyleEdit];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 非编辑状态
    if (!_isEditingCell)
    {
        if (indexPath.section == 0) {
            if (self.favoriteTitleArray.count > indexPath.row) {
                if (self.FinishOrChooseBlock) {
                    self.FinishOrChooseBlock(self.favoriteTitleArray, self.favoriteTitleArray[indexPath.row]);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        return;
    }
    // 编辑状态
    if (self.favoriteTitleArray.count <= 1 && indexPath.section == 0) return;
    NSMutableArray *willAddArray;
    NSMutableArray *willMinusArray;
    if (indexPath.section == 0) {
        willAddArray = self.recommendTitleArray;
        willMinusArray = self.favoriteTitleArray;
    }
    else
    {
        willAddArray = self.favoriteTitleArray;
        willMinusArray = self.recommendTitleArray;
    }
    
    NSInteger row = indexPath.row;
    
    if (willMinusArray.count > row) {
        MARWYNewCategoryTitleModel *model = willMinusArray[row];
        [willMinusArray removeObjectAtIndex:row];
        [willAddArray addObject:model];
        [self.collectionView reloadData];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint location = [longPress locationInView:_collectionView];
    
    _isChange = NO;
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [_movingCell removeFromSuperview];
            _movingCell = nil;
            self.movingIndexPath = [_collectionView indexPathForItemAtPoint:location];
            UICollectionViewCell *cell = nil;
            if (self.movingIndexPath && self.movingIndexPath.section == 0) {
                cell = [_collectionView cellForItemAtIndexPath:self.movingIndexPath];
            }
            else
            {
                self.movingIndexPath = nil;
            }
            if (!self.movingIndexPath) return;

            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cell];
            self.movingCell = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.movingCell setEditStyle:MARWYNewCategoryCellStyleNone];
            self.movingCell.frame = cell.frame;
            self.movingCell.center = cell.center;
            [self.collectionView addSubview:self.movingCell];
            [self.collectionView reloadItemsAtIndexPaths:@[self.movingIndexPath]];
            
            [self.cellAttributesArray removeAllObjects];
            for (int i = 0; i < self.favoriteTitleArray.count; i++) {
                [self.cellAttributesArray addObject:[_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
            
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            if (!self.movingCell) return;
            self.movingCell.center = [longPress locationInView:_collectionView];
            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                if (CGRectContainsPoint(attributes.frame, _movingCell.center) && _movingIndexPath != attributes.indexPath) {
                    _isChange = YES;
                    MARWYNewCategoryTitleModel *model = self.favoriteTitleArray[_movingIndexPath.row];
                    [self.favoriteTitleArray removeObjectAtIndex:_movingIndexPath.row];
                    [self.favoriteTitleArray insertObject:model atIndex:attributes.indexPath.row];
                    [self.collectionView moveItemAtIndexPath:_movingIndexPath toIndexPath:attributes.indexPath];
                    _movingIndexPath = attributes.indexPath;
                }
            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateEnded: {
            if (!self.movingCell) return;
            if (!_isChange) {
                [UIView animateWithDuration:0.25f animations:^{
                    _movingCell.center = [_collectionView layoutAttributesForItemAtIndexPath:_movingIndexPath].center;
                } completion:^(BOOL finished) {
                    [_movingCell removeFromSuperview];
                    _movingCell = nil;
                    NSIndexPath *needUpdateIndexPath = _movingIndexPath;
                    _movingIndexPath = nil;
                    if (needUpdateIndexPath) {
                        [_collectionView reloadItemsAtIndexPaths:@[needUpdateIndexPath]];
                    }
                }];
            }
        }
            
            break;
            
        default:
            break;
    }
    
}

- (NSMutableArray *)cellAttributesArray {
    if(_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
