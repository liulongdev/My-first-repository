//
//  MARWXArticleCategoryModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARBaseDBModel.h"
@interface MARWXArticleCategoryModel : MARBaseDBModel

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *name;

@end

/*
 cid    string    分类Id
 name    string    分类名称
 */
