//
//  MARWebViewController.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARWebViewController.h"
#if __has_include(<Masonry.h>)
#import <Masonry.h>
#endif


#if __has_include(<WebKit/WebKit.h>)
@interface MARWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, assign) BOOL hasLoadFirstRequest;
@end

@implementation MARWebViewController

- (instancetype) initWithURL:(NSURL*)URL{
    if(!(self=[super init])) return nil;
    self.URL = URL;
    return self;
}
- (instancetype) initWithURLRequest:(NSURLRequest*)URLRequest{
    if(!(self=[super init])) return nil;
    self.URLRequest = URLRequest;
    return self;
}

#pragma mark View Lifecycle
- (void) loadView{
    [super loadView];
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.webView];

    if (self.navigationController.navigationBar.translucent) {
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(MARCONTENTINSETTOP(self), 0, 0, 0);
    }
#if __has_include(<Masonry.h>)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.navigationController.navigationBar.translucent)
        {
            make.top.mas_equalTo(self.view);
        }
        else
            make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.leading.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.trailing.mas_equalTo(self.view);
    }];
#endif
}
- (void) viewDidLoad{
    [super viewDidLoad];
    MARAdjustsScrollViewInsets_NO(self.webView.scrollView, self);
    if(self.URL)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    else if(self.URLRequest)
        [self.webView loadRequest:self.URLRequest];
}

#pragma mark UIWebviewDelegate

//在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (!_hasLoadFirstRequest) {
        _hasLoadFirstRequest = YES;
        [self startRightActivityIndicator];
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        if (self.navigationController && (navigationAction.navigationType == UIWebViewNavigationTypeFormSubmitted || navigationAction.navigationType == UIWebViewNavigationTypeLinkClicked)) {
            MARWebViewController *vc = [[[self class] alloc] initWithURLRequest:navigationAction.request];
            [self mar_pushViewController:vc animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else
            decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

- (void)startRightActivityIndicator
{
    UIActivityIndicatorViewStyle style;
    if(self.navigationController.navigationBar.barTintColor){
        UIColor *clr = self.navigationController.navigationBar.barTintColor;
        const CGFloat *componentColors = CGColorGetComponents(clr.CGColor);
        CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
        style = colorBrightness < 0.6 ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray ;
    }else{
        style = UIActivityIndicatorViewStyleGray;
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [indicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    __weak __typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        weakSelf.title = response;
    }];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    __weak __typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        weakSelf.title = response;
    }];
    self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(self.navigationController && (navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeLinkClicked)){
        MARWebViewController *vc = [[[self class] alloc] initWithURLRequest:request];
        //        [self mar_pushViewController:vc animated:YES];
        [self mar_pushViewController:vc animated:YES];
        return NO;
    }
    
    return YES;
}

@end

#else
@interface MARWebViewController ()<UIWebViewDelegate>

@end

@implementation MARWebViewController

- (instancetype) initWithURL:(NSURL*)URL{
    if(!(self=[super init])) return nil;
    self.URL = URL;
    return self;
}
- (instancetype) initWithURLRequest:(NSURLRequest*)URLRequest{
    if(!(self=[super init])) return nil;
    self.URLRequest = URLRequest;
    return self;
}

#pragma mark View Lifecycle
- (void) loadView{
    [super loadView];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.webView];
#if __has_include(<Masonry.h>)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.leading.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        make.trailing.mas_equalTo(self.view);
    }];
#endif
}
- (void) viewDidLoad{
    [super viewDidLoad];
    if(self.URL)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    else if(self.URLRequest)
        [self.webView loadRequest:self.URLRequest];
}

#pragma mark UIWebviewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView{
    
    UIActivityIndicatorViewStyle style;
    if(self.navigationController.navigationBar.barTintColor){
        UIColor *clr = self.navigationController.navigationBar.barTintColor;
        const CGFloat *componentColors = CGColorGetComponents(clr.CGColor);
        CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
        style = colorBrightness < 0.6 ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray ;
    }else{
        style = UIActivityIndicatorViewStyleGray;
    }
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [indicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    //    self.navigationItem.rightBarButtonItem = self.actionBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    self.navigationItem.rightBarButtonItem = self.actionBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(self.navigationController && (navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeLinkClicked)){
        MARWebViewController *vc = [[[self class] alloc] initWithURLRequest:request];
        [self mar_pushViewController:vc animated:YES];
        return NO;
    }
    
    return YES;
}

@end

#endif


