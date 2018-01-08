//
//  MARWYNewNetworkManager.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MARWYNewRequest.h"
#import "MARWYNewResponse.h"
#import "MARWYNewModel.h"
#import "MARWYNewDetailModel.h"
#import "MARWYVideoNewDetailModel.h"
@interface MARWYNewNetworkManager : NSObject

+ (void)getNewTitleListSuccess:(void (^)(NSArray<MARWYNewCategoryTitleModel *> * categoryTitleArray))success
                       failure:(MARNetworkFailure)failure;

+ (void)getNewArticleList:(MARWYGetNewArticleListR *)param
                  success:(void (^)(NSArray<MARWYNewModel *> * array))success
                  failure:(MARNetworkFailure)failure;

+ (void)getNewArticleList2:(MARWYGetNewArticleListR *)param
                   success:(void (^)(NSArray<MARWYNewModel *> * array))success
                   failure:(MARNetworkFailure)failure;

+ (void)getNewArticleList3:(MARWYGetNewArticleListR *)param
                   success:(void (^)(NSArray<MARWYNewModel *> * array))success
                   failure:(MARNetworkFailure)failure;

+ (void)getNewArticleList4:(MARWYGetNewArticleListR *)param
                   success:(void (^)(NSArray<MARWYNewModel *> * array))success
                   failure:(MARNetworkFailure)failure;

//+ (void)getPhotoNewList:(MARWYGetPhotoNewListR *)param
//                success:(MARNetworkSuccess)success
//                failure:(MARNetworkFailure)failure;

+ (void)getTouTiaoNewList:(MARWYGetNewArticleListR *)param
                  success:(void (^)(NSArray<MARWYNewModel *> * array))success
                  failure:(MARNetworkFailure)failure;

+ (void)getChanListNews:(MARWYGetNewArticleListR *)param
                success:(void (^)(NSArray<MARWYNewModel *> * array))success
                failure:(MARNetworkFailure)failure;

+ (void)getVideoNewDetailWithSkipId:(NSString *)skipId
                            success:(MARNetworkSuccess)success
                            failure:(MARNetworkFailure)failure;

+ (void)getNewDetailWithDocId:(NSString *)docId
                      success:(MARNetworkSuccess)success
                      failure:(MARNetworkFailure)failure;

+ (void)getVideoCategoryTitleListSuccess:(void (^)(NSArray <MARWYVideoCategoryTitleModel *> *categoryArray))success
                                failure:(MARNetworkFailure)failure;

+ (void)getVideoNewList:(MARWYGetVideoNewListR *)param
                success:(void (^)(NSArray <MARWYVideoNewModel *> *array))success
                failure:(MARNetworkFailure)failure;


@end
