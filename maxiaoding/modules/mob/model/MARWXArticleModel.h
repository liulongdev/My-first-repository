//
//  MARWXArticleModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARBaseDBModel.h"
@interface MARWXArticleModel : MARBaseDBModel

@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger hitCount;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSString *sourceUrl;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *thumbnails;
@property (nonatomic, strong) NSString *title;

- (NSString *)getFirstThumbnail;
- (NSArray<NSString *> *)getThumbnailArray;

@end

/*
 retCode    string    返回码
 msg    string    返回说明
 result    string    返回结果集
 curPage    int    当前页
 total    int    总条数
 id    string    文章id
 cid    string    分类Id
 title    string    文章标题
 subTitle    string    文章副标题
 sourceUrl    string    文章来源
 pubTime    string    文章的发布时间
 thumbnails    string    导航缩略图，多个图片用$分割
 */
