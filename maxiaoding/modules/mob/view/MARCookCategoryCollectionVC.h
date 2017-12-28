//
//  MARCookCategoryCollectionVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/26.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"

@interface MARCookCategoryCollectionVC : MARBaseViewController

@property (nonatomic, assign) BOOL isSelectStyle;
@property (nonatomic, strong) MARCookCategoryModel *selectCookCategory;
@property (nonatomic, copy) void (^selectedCallback)(MARCookCategoryModel *);

@end
