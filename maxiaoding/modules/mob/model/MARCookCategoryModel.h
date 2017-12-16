//
//  MARCookCategoryModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/16.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseDBModel.h"

@interface MARCookCategoryModel : MARBaseDBModel <NSCopying>
@property (nonatomic, strong) NSString *ctgId;      // 分类ID
@property (nonatomic, strong) NSString *name;       // 分类描述
@property (nonatomic, strong) NSString *parentId;   // 上层分类ID
@end

@interface MARCookCategoryMenuModel : MARBaseDBModel

@property (nonatomic, strong) NSString *ctgId;      // 分类ID
@property (nonatomic, strong) NSString *name;       // 分类描述
@property (nonatomic, strong) NSString *parentId;   // 上层分类ID 暂时无用
@property (nonatomic, strong) NSArray<MARCookCategoryModel *> *childs;
@end
@class MARCookRecipe;
@interface MARCookDetailModel : MARBaseDBModel <MARModelDelegate>

@property (nonatomic, strong) NSString *menuId;                 // 菜谱id
@property (nonatomic, strong) NSArray<NSString *> *ctgIds;      // 分类ID集合
@property (nonatomic, strong) NSString *ctgTitles;              // 分类标签
@property (nonatomic, strong) MARCookRecipe *recipe;                 // 制作步骤 objcet的字符串 格式为：[{}]
@property (nonatomic, strong) NSString *name;                   // 菜谱名称
@property (nonatomic, strong) NSString *thumbnail;              // 预览图地址

//- (NSArray *)

@end

@class MARCookStep;
@interface MARCookRecipe : NSObject <NSCoding, MARModelDelegate>

@property (nonatomic, strong) NSString *title;              // 标题
@property (nonatomic, strong) NSString *img;                // 图片
@property (nonatomic, strong) NSString *ingredients;        // 需要的材料
@property (nonatomic, strong) NSString *sumary;             // 总结
@property (nonatomic, strong) NSArray<MARCookStep *> *method;   // img 图片 step 步骤

@property (nonatomic, strong) NSArray<MARCookStep *> *wrapperMethods;

@end

@interface MARCookStep : NSObject <NSCoding>

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *step;

@end

