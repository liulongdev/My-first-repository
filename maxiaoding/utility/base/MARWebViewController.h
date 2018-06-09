//
//  MARWebViewController.h
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARBaseViewController.h"

#if __has_include("MARSocialShareManager.h")
#define MARSocialShareManagerOn
#define MARSocailShareWithImage
#import "MARSocialShareManager.h"
#endif

#if __has_include(<WebKit/WebKit.h>)
//#define MARWebVCUseWebKitOn
#ifdef MARWebVCUseWebKitOn
#undef MARSocailShareWithImage      // 如果用WkWebview无法截图
#endif
#import <WebKit/WebKit.h>
#endif

@interface MARWebViewController : MARBaseViewController

/** Initializes a web vew controller that will load the given `NSURL` object.
 @param URL A `NSURL` object that will loaded by the `UIWebView`.
 @return An initialized `TKWebViewController` object or nil if the object couldn’t be created.
 */
- (instancetype) initWithURL:(NSURL*)URL;// NS_DESIGNATED_INITIALIZER;

/** Initializes a web vew controller that will load the given `URLRequest` object.
 @param URLRequest A `URLRequest` object that will loaded by the `UIWebView`.
 @return An initialized `TKWebViewController` object or nil if the object couldn’t be created.
 */
- (instancetype) initWithURLRequest:(NSURLRequest*)URLRequest;// NS_DESIGNATED_INITIALIZER;

///----------------------------
/// @name Properties
///----------------------------
/** The URL that will be loaded by the web view. */
@property (nonatomic,strong) NSURL *URL;

/** The URLRequest that will be loaded by the web view. */
@property (nonatomic,strong) NSURLRequest *URLRequest;

/** The html that will be loaded by the web view. */
@property (nonatomic,strong) NSString *htmlString;

/** Returns the `UIWebView`    managed by the controller object. */
#ifdef MARWebVCUseWebKitOn
@property (nonatomic,strong) WKWebView *webView;
#else
@property (nonatomic,strong) UIWebView *webView;
#endif

#ifdef MARSocialShareManagerOn
@property (nonatomic,strong) MARSocialShareMessageModel *messageModel;
#endif

@end
