//
//  MARWYVideoPlayNewListVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"
#import "MARWYNewModel.h"

@interface MARWYVideoPlayNewListPropertyModel : NSObject
@property (nonatomic, strong) MARWYVideoCategoryTitleModel *categoryModel;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) NSMutableArray<MARWYVideoNewModel *> *wyNewArray;
@property (nonatomic, assign) NSInteger lastLoadTimeStamp;
@property (nonatomic, assign) NSInteger refreshLoadFn;
@property (nonatomic, assign) BOOL isDataEmpty;

- (instancetype)initWithCategoryModel:(MARWYVideoCategoryTitleModel *)model;

@end

@interface MARWYVideoPlayNewListVC : MARBaseViewController
@property (nonatomic, strong) MARWYVideoPlayNewListPropertyModel *model;

- (void)locationMediaCell;

@end
