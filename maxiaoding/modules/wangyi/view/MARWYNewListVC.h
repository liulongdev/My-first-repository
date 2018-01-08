//
//  MARWYNewListVC.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/6.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"
#import "MARWYNewNetworkManager.h"
#import <VTMagic.h>

@interface MARNewListPropertyModel : NSObject
@property (nonatomic, strong) MARWYNewCategoryTitleModel *categoryModel;
@property (nonatomic, assign) CGPoint contentOffset;
@property (nonatomic, strong) NSMutableArray *wyNewArray;
@property (nonatomic, assign) NSInteger lastLoadTimeStamp;
@property (nonatomic, assign) NSInteger refreshLoadFn;
@property (nonatomic, assign) BOOL isDataEmpty;

- (instancetype)initWithCategoryModel:(MARWYNewCategoryTitleModel *)model;

@end

@interface MARWYNewListVC : MARBaseViewController <VTMagicReuseProtocol>
@property (nonatomic, strong) MARNewListPropertyModel *model;
//@property (nonatomic, strong) MARWYNewCategoryTitleModel *categoryModel;

@end
