//
//  MARWYNewDetailModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/6.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MARWYNewDetailSourceInfoModel;
@class MARWYNewDetailVideoModel;
@class MARWYNewDetailImageModel;
@class MARWYNewDetailTopicModel;
@interface MARWYNewDetailModel : NSObject <MARModelDelegate>

@property (nonatomic, strong) NSString *advertiseType;
@property (nonatomic, strong) NSString *articleTags;
@property (nonatomic, strong) NSString *articleType;
@property (nonatomic, strong) NSArray *boboList;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSArray *book;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *dkeys;
@property (nonatomic, strong) NSString *docid;
@property (nonatomic, strong) NSString *ec;
@property (nonatomic, strong) NSDictionary *entertainment;  // {"code":1}
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, strong) NSArray<MARWYNewDetailImageModel *> *img;
@property (nonatomic, strong) NSArray *link;
@property (nonatomic, assign) BOOL picnews;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, strong) NSArray *relative_sys;
@property (nonatomic, strong) NSString *replyBoard;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, strong) NSArray *searchKw;
@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) MARWYNewDetailSourceInfoModel *sourceinfo;
@property (nonatomic, strong) NSString *statement;
@property (nonatomic, strong) NSString *template;
@property (nonatomic, assign) NSInteger threadAgainst;
@property (nonatomic, assign) NSInteger *threadVote;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<MARWYNewDetailTopicModel *> *topiclist;
@property (nonatomic, strong) NSArray<MARWYNewDetailTopicModel *> *topiclist_news;
@property (nonatomic, strong) MARWYNewDetailVideoModel *video;
@property (nonatomic, strong) NSString *voicecomment;
@property (nonatomic, strong) NSArray *votes;
@property (nonatomic, strong) NSArray *ydbaike;

//@property (nonatomic, strong) NSString * ;
//@property (nonatomic, assign) NSInteger ;
//@property (nonatomic, assign) BOOL ;

- (NSString *)getHtmlString;

- (NSString *)getBodyString;

@end

@interface MARWYNewDetailImageModel : NSObject
@property (nonatomic, strong) NSString *alt;
@property (nonatomic, strong) NSString *pixel;  // "550*144"
@property (nonatomic, strong) NSString *ref;
@property (nonatomic, strong) NSString *src;
@end

@interface MARWYNewDetailRelativeSysModel : NSObject
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *imgsrc;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, strong) NSString *recallBy;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@end

@interface MARWYNewDetailSourceInfoModel : NSObject
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *ename;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
@property (nonatomic, strong) NSString *topic_icons;
@end

@interface MARWYNewDetailTopicModel : NSObject
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *ename;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, assign) BOOL hasCover;
@property (nonatomic, strong) NSString *subnum;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
@end

@interface MARWYNewDetailVideoModel : NSObject
@property (nonatomic, strong) NSString *alt;
@property (nonatomic, strong) NSString *appurl;
@property (nonatomic, strong) NSString *broadcast;
@property (nonatomic, strong) NSString *commentboard;
@property (nonatomic, strong) NSString *commentid;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *ref;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *topicid;
@property (nonatomic, strong) NSString *url_m3u8;
@property (nonatomic, strong) NSString *url_mp4;
@property (nonatomic, strong) NSString *vid;
@end


