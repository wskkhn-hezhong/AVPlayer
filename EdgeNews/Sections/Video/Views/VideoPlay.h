//
//  VideoPlay.h
//  EdgeNews
//
//  Created by lanouhn on 15/11/30.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class VideoPlay;

@protocol VideoPlayDelegate <NSObject>

@optional
//向左转全屏播放
- (void)turnLeft:(VideoPlay *)playerView;
//左全屏转回小窗口播放
- (void)leftTurnBack:(VideoPlay *)playerView;
//向右转全屏播放
- (void)turnRight:(VideoPlay *)playerView;
//右全屏转窗口播放
- (void)rtghtTurnBack:(VideoPlay *)playerView;
//播放失败
- (void)AVPlayerStatusFailed:(VideoPlay *)playerView;

@end





@interface VideoPlay : UIView

@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) AVPlayerLayer *playerLayer;
@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIView *bottom;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UIProgressView *videoProgress;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UIButton *fullScreenButton;
@property (nonatomic, retain) NSString *totalTime;
@property (nonatomic, retain) id playbackTimeObserver;
@property (nonatomic, assign)id<VideoPlayDelegate> delegate;



@end
