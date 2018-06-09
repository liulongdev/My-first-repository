//
//  MARWYNewModel.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/4.
//  strongright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MARWYNewModel : MARBaseDBModel
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
/**
 *  新闻发布时间
 */
@property (nonatomic, strong) NSString *ptime;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  多图数组
 */
@property (nonatomic, assign) NSInteger imgsum;     // 多图数量
@property (nonatomic, strong) NSArray *imgextra;
@property (nonatomic, strong) NSString *photosetID;
@property (nonatomic, assign) NSInteger hashead;
@property (nonatomic, assign) NSInteger *hasImg;
@property (nonatomic, strong) NSString *lmodify;    // 时间
@property (nonatomic, strong) NSString *mtime;      // 时间
@property (nonatomic, strong) NSString *template;
@property (nonatomic, strong) NSString *skipType;
/**
 *  跟帖人数
 */
@property (nonatomic, assign)NSInteger replyCount;
@property (nonatomic, assign)NSInteger *votecount;
@property (nonatomic, assign)NSInteger *voteCount;
@property (nonatomic, strong) NSString *postid;     // 帖子标识

@property (nonatomic, strong) NSString *alias;
/**
 *  新闻ID
 */
@property (nonatomic, strong) NSString *docid;      // 标识url中有
@property (nonatomic, assign) BOOL hasCover;
@property (nonatomic, assign) NSInteger *hasAD;
@property (nonatomic, assign) NSInteger *priority;
@property (nonatomic, strong) NSString *cid;        // 分类id
@property (nonatomic, strong) NSArray *videoID;
/**
 *  图片连接
 */
@property (nonatomic, strong) NSString *imgsrc;
@property (nonatomic, assign) BOOL hasIcon;
@property (nonatomic, strong) NSString *ename;
@property (nonatomic, strong) NSString *skipID;
@property (nonatomic, assign) NSInteger order;
/**
 *  描述
 */
@property (nonatomic, strong) NSString *digest;         // 描述

@property (nonatomic, strong)NSArray *editor;

@property (nonatomic, strong) NSString *url_3w;         // 电脑端url
@property (nonatomic, strong) NSString *specialID;
@property (nonatomic, strong) NSString *timeConsuming;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *adTitle;
@property (nonatomic, strong) NSString *ltitle;         // 标题
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *source;         // 来源


@property (nonatomic, strong) NSString *TAGS;
@property (nonatomic, strong) NSString *TAG;
/**
 *  大图样式
 */
@property (nonatomic, assign) NSInteger imgType;
@property (nonatomic, strong) NSArray *specialextra;


@property (nonatomic, strong) NSString *boardid;
@property (nonatomic, strong) NSString *commentid;
@property (nonatomic, assign) NSInteger *speciallogo;
@property (nonatomic, strong) NSString *specialtip;
@property (nonatomic, strong) NSString *specialadlogo;

@property (nonatomic, strong) NSString *pixel;
@property (nonatomic, strong) NSArray *applist;

@property (nonatomic, strong) NSString *wap_portal;
@property (nonatomic, strong) NSString *live_info;
@property (nonatomic, strong) NSString *ads;
@property (nonatomic, strong) NSString *videosource;

//@property (nonatomic, strong) NSString * ;
//@property (nonatomic, assign) NSInteger ;
//@property (nonatomic, assign) BOOL ;


// ？？？？？
//@property (nonatomic, strong) NSString *professional;
//@property (nonatomic, strong) NSString *topic_background;
//@property (nonatomic, strong) NSString *dkeys;


// 视频
//videoTopic  obj



@end


@interface MARWYNewCategoryTitleModel : MARBaseDBModel <NSCopying>
@property (nonatomic, strong) NSString *tid;        // 获取新闻列表需要用到
@property (nonatomic, strong) NSString *tname;      // 分类名称
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *ename;      // 分类名称的汉语拼音
@property (nonatomic, assign) NSInteger ad_type;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) NSInteger hasAD;
@property (nonatomic, assign) BOOL hasCover;
@property (nonatomic, assign) BOOL hasIcon;
@property (nonatomic, assign) NSInteger hashead;
@property (nonatomic, assign) BOOL headLine;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, assign) NSInteger isHot;
@property (nonatomic, assign) NSInteger isNew;
@property (nonatomic, strong) NSString *recommend;
@property (nonatomic, assign) NSInteger recommendOrder;
@property (nonatomic, strong) NSString *showType;
@property (nonatomic, assign) NSInteger special;
@property (nonatomic, strong) NSString *subnum;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *tagDate;
@property (nonatomic, strong) NSString *template;
@property (nonatomic, strong) NSString *topicid;
// 自定义
@property (nonatomic, assign) BOOL notAttention;
@property (nonatomic, assign) NSInteger orderNumber;

+ (NSArray *)getArrayFavorite:(BOOL)isFavorite;

@end

@interface MARWYVideoCategoryTitleModel : MARBaseDBModel <NSCopying>
@property (nonatomic, strong) NSString *categorys;
@property (nonatomic, strong) NSString *cname;
@property (nonatomic, strong) NSString *ename;
@property (nonatomic, assign) NSInteger sensitive;

@end

@interface MARWYPhotoNewPhotoDetialModel : MARBaseDBModel

@property (nonatomic, strong) NSString *cimgurl;
@property (nonatomic, strong) NSString *imgtitle;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *newsurl;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *photohtml;
@property (nonatomic, strong) NSString *photoid;
@property (nonatomic, strong) NSString *simgurl;
@property (nonatomic, strong) NSString *squareimgurl;
@property (nonatomic, strong) NSString *timgurl;

@end

@interface MARWYPhotoNewModel : MARBaseDBModel <MARModelDelegate>

@property (nonatomic, strong) NSString *autoid;
@property (nonatomic, strong) NSString *boardid;
@property (nonatomic, strong) NSString *clientadurl;
@property (nonatomic, strong) NSString *commenturl;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *createdate;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSString *datatime;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger imgsum;
@property (nonatomic, strong) NSString *neteasecode;
@property (nonatomic, strong) NSArray<MARWYPhotoNewPhotoDetialModel *> *photos;
@property (nonatomic, strong) NSString *postid;
@property (nonatomic, strong) NSArray *relatedids;
@property (nonatomic, strong) NSString *reporter;
@property (nonatomic, strong) NSString *scover;
@property (nonatomic, strong) NSString *series;
@property (nonatomic, strong) NSString *setname;
@property (nonatomic, strong) NSString *settag;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *tcover;
@property (nonatomic, strong) NSString *url;

@end

@interface MARWYVideoTopicModel : MARBaseDBModel <NSCopying, NSCoding>
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *ename;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
@property (nonatomic, strong) NSString *topic_icons;
@end

@interface MARWYVideoNewModel : MARBaseDBModel <MARModelDelegate>
//@property (nonatomic, strong) NSString * ;
//@property (nonatomic, assign) NSInteger ;
//@property (nonatomic, assign) BOOL ;

@property (nonatomic, assign) NSInteger autoPlay;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, assign) NSInteger danmu;
@property (nonatomic, strong) NSString *myDescription;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) NSString *m3u8_url;
@property (nonatomic, strong) NSString *mp4_url;
@property (nonatomic, assign) NSInteger playCount;
@property (nonatomic, assign) NSInteger playersize;
@property (nonatomic, strong) NSString *program;
@property (nonatomic, strong) NSString *prompt;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, strong) NSString *replyBoard;
@property (nonatomic, strong) NSString *replyid;
@property (nonatomic, strong) NSString *sectiontitle;
@property (nonatomic, assign) NSInteger sizeHD;
@property (nonatomic, assign) NSInteger sizeSD;
@property (nonatomic, assign) NSInteger sizeSHD;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *topicDesc;
@property (nonatomic, strong) NSString *topicImg;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *topicSid;
@property (nonatomic, strong) NSString *vid;
@property (nonatomic, strong) MARWYVideoTopicModel *videoTopic;
@property (nonatomic, strong) NSString *videosource;
@end

@interface MARWYTouTiaoNewModel : MARBaseDBModel
/*
 "adtype":0,
 "boardid":"dy_wemedia_bbs",
 "clkNum":0,
 "danmu":1,
 "docid":"D7BB9B4S05198V5Q",
 "downTimes":1,
 "hasAD":1,
 "hasHead":0,
 "id":"D7BB9B4S05198V5Q",
 "img":"http://spider.nosdn.127.net/4fc6bd79ad89e11264fdf03a07a024bb.jpeg",
 "imgType":0,
 "imgnewextra":[
 {
 "imgsrc":"http://spider.nosdn.127.net/b9664c9636465f3d09aa85a91d5cc6bf.jpeg"
 },
 {
 "imgsrc":"http://spider.nosdn.127.net/3086550699be4ac5ef04591e743c7eaf.jpeg"
 }
 ],
 "imgsrc":"http://spider.nosdn.127.net/4fc6bd79ad89e11264fdf03a07a024bb.jpeg",
 "imgsum":0,
 "interest":"汽车",
 "lmodify":"2018-01-04 22:27:54",
 "picCount":0,
 "program":"Rpic2",
 "ptime":"2018-01-04 21:39:29",
 "rank":0,
 "recNews":0,
 "recSource":"汽车",
 "recTime":1515137935,
 "recType":-1,
 "recprog":"LMA4",
 "refreshPrompt":0,
 "replyCount":6312,
 "replyid":"D7BB9B4S05198V5Q",
 "source":"EMBA",
 "template":"normal1",
 "title":"没买车的恭喜了！宝马、福特、本田共同宣布！",
 "unlikeReason":[
 "行业/1",
 "美国汽车/2",
 "高端车/2",
 "福特/3",
 "来源:EMBA/4",
 "内容质量差/6"
 ],
 "upTimes":513
 */
@end
