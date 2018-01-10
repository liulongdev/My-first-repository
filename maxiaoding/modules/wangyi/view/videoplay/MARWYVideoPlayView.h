//
//  MARWYVideoPlayView.h
//  maxiaoding
//
//  Created by Martin.Liu on 2018/1/8.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, MARVideoStatus) {
    MARVideoStatusPlaying = 1,
    MARVideoStatusPause,
    MARVideoStatusFinish,
    MARVideoStatusRemoved,
};

@protocol MARWYVideoPlayViewDelegate <NSObject>

@optional
- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface MARWYVideoPlayView : UIView

+ (instancetype)videoPlayView;

@property (weak, nonatomic) id<MARWYVideoPlayViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) MARVideoStatus status;
-(void)suspendPlayVideo;

-(void)pause;

-(void)play;

-(void)resetPlayView;

@end
