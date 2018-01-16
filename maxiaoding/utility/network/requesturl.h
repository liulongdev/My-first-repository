//
//  requesturl.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/31.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#ifndef requesturl_h
#define requesturl_h

#define URLAppend(_host_, _serviceurl_)     [[NSURL URLWithString:_serviceurl_ relativeToURL:[NSURL URLWithString:_host_]] absoluteString]

//#define SERVERHOST @"http://192.168.31.166:3000"
#define SERVERHOST @"https://wx.liulong.site"

#define SHORTAPI_ThirdPlatformLogin         @"api/core/v1/user/thirdPlatformLogin"  // 第三方平台登陆
#define SHORTAPI_RegisterUser               @"api/core/v1/user/register"            // 注册用户
#define SHORTAPI_LoginWithPhone             @"api/core/v1/user/loginWithPhone"      // 手机登录
#define SHORTAPI_QuickLoginWithPhone        @"api/core/v1/user/quickLoginWithPhone" // 手机快速登录
#define SHORTAPI_ChangePassword             @"api/core/v1/user/changePassword"      // 更改密码
#define SHORTAPI_SetPassword                @"api/core/v1/user/setPassword"         // 设置密码
#define SHORTAPI_UserExistWithPhone         @"api/core/v1/user/userExistWithPhone" // 是否存在该手机号的用户
#define SHORTAPI_BindPhone                  @"api/core/v1/user/bindPhone"          // 绑定手机号
#define SHORTAPI_AddWYVideoNewCollection    @"api/core/v1/wy/new/addVideoNewCollection"    // 增加视频新闻收藏

#define SERVERAPI_ThirdPlatformLogin        URLAppend(SERVERHOST, SHORTAPI_ThirdPlatformLogin)
#define SERVERAPI_RegisterUser              URLAppend(SERVERHOST, SHORTAPI_RegisterUser)
#define SERVERAPI_LoginWithPhone            URLAppend(SERVERHOST, SHORTAPI_LoginWithPhone)
#define SERVERAPI_QuickLoginWithPhone       URLAppend(SERVERHOST, SHORTAPI_QuickLoginWithPhone)
#define SERVERAPI_ChangePassword            URLAppend(SERVERHOST, SHORTAPI_ChangePassword)
#define SERVERAPI_SetPassword               URLAppend(SERVERHOST, SHORTAPI_SetPassword)
#define SERVERAPI_UserExistWithPhone        URLAppend(SERVERHOST, SHORTAPI_UserExistWithPhone)
#define SERVERAPI_SetPassword               URLAppend(SERVERHOST, SHORTAPI_SetPassword)
#define SERVERAPI_BindPhone                 URLAppend(SERVERHOST, SHORTAPI_BindPhone)
#define SERVERAPI_AddWYVideoNewCollection   URLAppend(SERVERHOST, SHORTAPI_AddWYVideoNewCollection)

//https://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html         // 获取所有类别
// /recommend/getSubDocPic?from=toutiao&prog=Rpic2&open=&openpath=&passport=&devId=4q9wyqO%2BqQBTBHM8f1fMsbVhBeT2jN%2BpF2piB1fvCVBW8vGHludHKO1HgHn4Q%2BQf&version=31.0&spever=false&net=wifi&lat=YADB9fnO3fsBKsQUflb4ig%3D%3D&lon=4n8BYUV/zut3uONFBqLejQ%3D%3D&ts=1515070801&sign=VwZsYGHrDhYipV24Zn6YVeh5bDNqCxH4N9v/k9juIEt48ErR02zJ6/KXOnxX046I&encryption=1&canal=appstore&offset=0&size=10&fn=2 HTTP/1.1   // 获取今日头条的推荐新闻

#define WANGYIHOST @"https://c.m.163.com"
#define LIULONGHOST SERVERHOST
#define WYGetAllNewCategoryTitleList                @"nc/topicset/ios/subscribe/manage/listspecial.html"    // 获取网易新闻标题列表
#define WYGetRecommendNewList                       @"recommend/getSubDocPic"   // 获取头条 from=toutiao
#define WYGetNewArticleList1                        @"dlist/article/dynamic"    // 根据分类查询新闻列表
#define WYGetNewArticleList2                        @"nc/article/list"
#define WYGetNewArticleList3                        @"recommend/getChanListNews"                    // 特殊的需要
#define WYGetNewArticleList4                                               @"recommend/getComRecNews"
#define WYGetChanListNews                           @"/recommend/getChanListNews"   // 视频
#define WYGetPhotoNewDetail                         @"photo/api/set"          // 获取图片类型的新闻
// @"/nc/article/list/T1492136373327/0-20.html"
#define WYGetVideoNewDetail                         @"nc/video/detail"          // 获取视频类新闻具体描述
#define WY_GETNewDetail                             @"nc/article"               // 根据docid获取帖子详情
#define WYGetVideoCategoryTitleList                 @"recommend/video/tablist"      // 获取视频标签列表
#define WYGetVideoNewList                           @"/recommend/getChanListNews"   // 获取视频新闻列表


#define WYSERVER_GetAllNewCategoryTitleList         URLAppend(WANGYIHOST, WYGetAllNewCategoryTitleList)     // 获取网易新闻标题列表
#define WYSERVER_GetRecommendNewList                URLAppend(WANGYIHOST, WYGetRecommendNewList)            // 获取网易头条
#define WYSERVER_GetNewArticleList                  URLAppend(WANGYIHOST, WYGetNewArticleList1)         // 根据分类查询新闻列表
#define WYSERVER_GetNewArticleList2                  URLAppend(WANGYIHOST, WYGetNewArticleList2)             // 获取新闻列表
#define WYSERVER_GetNewArticleList3                  URLAppend(WANGYIHOST, WYGetNewArticleList3)             // 获取新闻列表 <需要自己的服务器>
#define WYSERVER_GetNewArticleList4                 URLAppend(WANGYIHOST, WYGetNewArticleList4)  // 根据分类查询新闻列表获取新闻列表         段子
#define WYSERVER_GetChanListNews                    URLAppend(WANGYIHOST, WYGetChanListNews)     // 视频
#define WYSERVER_GetPhotoNewDetail                  URLAppend(WANGYIHOST, WYGetPhotoNewDetail)                // 获取图片类型的新闻
#define WYSERVER_GetVideoNewDetail                  URLAppend(WANGYIHOST, WYGetVideoNewDetail)     // 获取新闻视频类的具体数据
#define WYSERVER_GETNewDetailWithDocId              URLAppend(WANGYIHOST, WY_GETNewDetail)

#define WYSERVER_GetVideoCategoryTitleList         URLAppend(WANGYIHOST, WYGetVideoCategoryTitleList)     // 获取视频标签列表
#define WYSERVER_GetVideoNewList                    URLAppend(WANGYIHOST, WYGetVideoNewList)     // 获取视频新闻列表



#endif /* requesturl_h */
