//
//  MARWYNewRequest.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MARWYNewRequest : NSObject
@property (nonatomic, strong) NSString *devId;
@property (nonatomic, strong) NSString *passport;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *spever;
@property (nonatomic, strong) NSString *net;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *canal;
@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSString *encryption;
@property (nonatomic, strong) NSString *sign;

- (void)setSignature;

@end

@interface MARWYSpecialNewRequest : NSObject
@property (nonatomic, strong) NSString *devId;
@property (nonatomic, strong) NSString *passport;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *spever;
@property (nonatomic, strong) NSString *net;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *canal;
@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSString *encryption;
@property (nonatomic, strong) NSString *sign;
@end

@interface MARWYGetNewListWithCategoryR : MARWYNewRequest
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger fn;
@property (nonatomic, strong) NSString *from;           //  MARWYNewCategoryTitleModel的tid

// 头条
// from = 'toutiao'
@property (nonatomic, strong) NSString *LastStdTime;
@property (nonatomic, strong) NSString *prog;
@property (nonatomic, strong) NSString *open;
@property (nonatomic, strong) NSString *openPath;
// channel
@property (nonatomic, strong) NSString *channel;
@end

@interface MARWYGetNewArticleListR : MARWYGetNewListWithCategoryR

@end

@interface MARWYGetTouTiaoNewListR : MARWYGetNewListWithCategoryR
// from = 'toutiao'
//@property (nonatomic, strong) NSString *LastStdTime;
//@property (nonatomic, strong) NSString *prog;
//
//
//@property (nonatomic, strong) NSString *open;
//@property (nonatomic, strong) NSString *openPath;
@end

@interface MARWYGetChanListNewsR : MARWYGetNewArticleListR
//@property (nonatomic, strong) NSString *channel;
@end

@interface MARWYGetPhotoNewListR : MARWYNewRequest

@end

@interface MARWYGetVideoNewListR : MARWYSpecialNewRequest
@property (nonatomic, strong) NSString *channel;    // T1457068979049
@property (nonatomic, strong) NSString *subtab;     // 视频标签model的ename
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger fn;
@end

//@interface MARAddVideoCollecionR : MARBaseRequest
//
//@end

