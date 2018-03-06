//
//  MARWYNewDetailModel.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/6.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARWYNewDetailModel.h"

@implementation MARWYNewDetailModel

+ (NSDictionary<NSString *,id> *)mar_modelContainerPropertyGenericClass
{
    return @{@"img": [MARWYNewDetailImageModel class],
             @"relative_sys": [MARWYNewDetailRelativeSysModel class],
             @"sourceinfo": [MARWYNewDetailSourceInfoModel class],
             @"topiclist": [MARWYNewDetailTopicModel class],
             @"topiclist_news":[MARWYNewDetailTopicModel class],
             @"video": [MARWYNewDetailVideoModel class]};
}

- (NSString *)getHtmlString
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />"];
    NSString *styleStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MARWYNewDetail" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil];
    [html appendFormat:@"<style>%@</style>", styleStr];
//    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"MARWYNewDetail" withExtension:@"css"]];
    [html appendFormat:@"<title>%@</title>", self.title];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self getBodyString]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    return html;
}

- (NSString *)getBodyString
{
    NSMutableString *body = [NSMutableString string];

    NSString *commentUrl = [NSString stringWithFormat:@"https://3g.163.com/touch/comment.html?docid=%@", self.docid];
    NSString *tagAStr = @"";
    if (self.replyCount > 0) {
        tagAStr = [NSString stringWithFormat:@"<a class=\"wy-newcomment\" href=\"%@\">%ld回帖</a><p>",commentUrl, (long)self.replyCount];
    }
    
    [body appendFormat:@"<div class=\"wy-title\">%@</div>",self.title];
    [body appendString:@"<div class=\"wy-time-comment-container\">"];
    [body appendFormat:@"<div class=\"wy-time\">%@</div>",self.ptime];
    [body appendString:tagAStr];
    if ([self.body mar_stringByTrim].length > 0) {
        [body appendFormat:@"<div class=\"wy_content\">%@<div>", self.body];
    }
    [body appendString:@"</div>"];
    for (MARWYNewDetailImageModel *imageModel in self.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"wy-img-parent\">"];
        NSArray *pixel = [imageModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject] floatValue];
        CGFloat height = [[pixel lastObject] floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.95;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        [imgHtml appendFormat:@"<img width=\"%f\" height=\"%f\" src=\"%@\">",width,height,imageModel.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:imageModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    
    if (_video) {
        NSMutableString *videoHtml = [NSMutableString string];
        [videoHtml appendFormat:@"<div class=\"wy-video-parent\">"];
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.95;
        CGFloat height = maxWidth * 3/4;
        [videoHtml appendFormat:@"<video width=\"%f\" height=\"%f\" controls><source src=\"%@\" type=\"%@\">您的浏览器不支持 HTML5 video 标签。</video>", maxWidth, height, self.video.url_mp4,@"video/mp4"];
        [videoHtml appendFormat:@"</div>"];
        
    }
    
    return body;
}

@end

@implementation MARWYNewDetailImageModel

@end

@implementation MARWYNewDetailRelativeSysModel

@end

@implementation MARWYNewDetailSourceInfoModel

@end

@implementation MARWYNewDetailTopicModel

@end

@implementation MARWYNewDetailVideoModel

@end
