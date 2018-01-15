//
//  MARWYChooseNewCategoryVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/11.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"
#import "MARWYNewModel.h"
@interface MARWYChooseNewCategoryVC : MARBaseViewController

@property (nonatomic, copy) void (^FinishOrChooseBlock)(NSArray<MARWYNewCategoryTitleModel *> *, MARWYNewCategoryTitleModel *);

@end
