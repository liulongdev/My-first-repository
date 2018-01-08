//
//  MARWYVideoNewListVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"
#import "MARWYNewModel.h"


@interface MARWYVideoNewListPropertyModel : NSObject
@property (nonatomic, strong) MARWYVideoCategoryTitleModel *categoryModel;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) NSMutableArray *wyNewArray;
@property (nonatomic, assign) NSInteger lastLoadTimeStamp;
@property (nonatomic, assign) NSInteger refreshLoadFn;
@property (nonatomic, assign) BOOL isDataEmpty;

- (instancetype)initWithCategoryModel:(MARWYVideoCategoryTitleModel *)model;

@end
@interface MARWYVideoNewListVC : MARBaseViewController
@property (nonatomic, strong) MARWYVideoNewListPropertyModel *model;
@end
