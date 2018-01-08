//
//  MARWYVideoPlayView.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface MARWYVideoPlayView : UIView

+ (instancetype)videoPlayView;

//@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong) AVPlayerItem *playerItem;

-(void)suspendPlayVideo;

-(void)pause;

-(void)play;

-(void)resetPlayView;

@end
