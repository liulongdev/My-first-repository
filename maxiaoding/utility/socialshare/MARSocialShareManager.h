//
//  MARSocialShareManager.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/7.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MARSocialPlatformType) {
    MARSocialPlatformType_UnKnown            = -2,
    //预定义的平台
    MARSocialPlatformType_Predefine_Begin    = -1,
    MARSocialPlatformType_Sina               = 0, //新浪
    MARSocialPlatformType_WechatSession      = 1, //微信聊天
    MARSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    MARSocialPlatformType_WechatFavorite     = 3,//微信收藏
    MARSocialPlatformType_QQ                 = 4,//QQ聊天页面
    MARSocialPlatformType_Qzone              = 5,//qq空间
    MARSocialPlatformType_TencentWb          = 6,//腾讯微博
    MARSocialPlatformType_AlipaySession      = 7,//支付宝聊天页面
    MARSocialPlatformType_YixinSession       = 8,//易信聊天页面
    MARSocialPlatformType_YixinTimeLine      = 9,//易信朋友圈
    MARSocialPlatformType_YixinFavorite      = 10,//易信收藏
    MARSocialPlatformType_LaiWangSession     = 11,//点点虫（原来往）聊天页面
    MARSocialPlatformType_LaiWangTimeLine    = 12,//点点虫动态
    MARSocialPlatformType_Sms                = 13,//短信
    MARSocialPlatformType_Email              = 14,//邮件
    MARSocialPlatformType_Renren             = 15,//人人
    MARSocialPlatformType_Facebook           = 16,//Facebook
    MARSocialPlatformType_Twitter            = 17,//Twitter
    MARSocialPlatformType_Douban             = 18,//豆瓣
    MARSocialPlatformType_KakaoTalk          = 19,//KakaoTalk
    MARSocialPlatformType_Pinterest          = 20,//Pinteres
    MARSocialPlatformType_Line               = 21,//Line
    
    MARSocialPlatformType_Linkedin           = 22,//领英
    
    MARSocialPlatformType_Flickr             = 23,//Flickr
    
    MARSocialPlatformType_Tumblr             = 24,//Tumblr
    MARSocialPlatformType_Instagram          = 25,//Instagram
    MARSocialPlatformType_Whatsapp           = 26,//Whatsapp
    MARSocialPlatformType_DingDing           = 27,//钉钉
    
    MARSocialPlatformType_YouDaoNote         = 28,//有道云笔记
    MARSocialPlatformType_EverNote           = 29,//印象笔记
    MARSocialPlatformType_GooglePlus         = 30,//Google+
    MARSocialPlatformType_Pocket             = 31,//Pocket
    MARSocialPlatformType_DropBox            = 32,//dropbox
    MARSocialPlatformType_VKontakte          = 33,//vkontakte
    MARSocialPlatformType_FaceBookMessenger  = 34,//FaceBookMessenger
    MARSocialPlatformType_Tim                = 35,// Tencent TIM
    
    MARSocialPlatformType_Predefine_end      = 999,
    
    //用户自定义的平台
    MARSocialPlatformType_UserDefine_Begin = 1000,
    MARSocialPlatformType_UserDefine_End = 2000,
};

typedef void(^MARSocialSharePlatformSelectionBlock)(MARSocialPlatformType platformType,NSDictionary* userInfo);
typedef void (^MARSocialRequestCompletionHandler)(id result,NSError *error);

typedef NS_ENUM(NSInteger, MARSocialShareMessageType){
    MARSocialShareMessageType_URL,
    MARSocialShareMessageType_VideoURL,
    MARSocialShareMessageType_Image,
};

@interface MARSocialShareMessageModel : NSObject <NSCopying , NSCoding>
@property (nonatomic, assign) MARSocialShareMessageType messageType;
@property (nonatomic, strong) NSString *title;          // 标题
@property (nonatomic, strong) id image;             // 图片 UIImage|NSData|NSString
@property (nonatomic, strong) id thumImage;         // 展示的缩略图 UIImage|NSData|NSString
@property (nonatomic, strong) NSString *URLString;      // webURL
@property (nonatomic, strong) NSString *shareDesc; // 描述
@end

@interface MARSocialShareManager : NSObject

/**
 *  显示分享面板
 *
 *  @param complete 回调block
 */
+ (void)showShareMenuViewInWindowWithMessage:(MARSocialShareMessageModel *)message complete:(MARSocialRequestCompletionHandler)complete;

/**
 *  设置预定义平台
 *
 *  @param preDefinePlatforms 预定于平台数组@see MARSocialPlatformType.
 *  开发者需要自己预定义自己需要的平台。
 *  此函数需要在MARSocialSharePlatformSelectionBlock之前调用，
 *  传入的平台必须是合法并且是core模块已经检测到的已经存在的平台，不然会被过滤掉(此条款是上线appStore审核的条件，开发者必须注意)
 */
+(void)setPreDefinePlatforms:(NSArray*)preDefinePlatforms;

+(void)setSupportPlatforms;

@end
