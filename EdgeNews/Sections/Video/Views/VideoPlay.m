//
//  VideoPlay.m
//  EdgeNews
//

#import "VideoPlay.h"
#import "MBProgressHUD.h"

@interface VideoPlay () {
    BOOL _isSmall;
    CGFloat totalMovelDuration;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIAlertView *alertView;

@end



@implementation VideoPlay

- (void)dealloc
{
    [_timer release];
    [_alertView release];
    [_playbackTimeObserver release];
    [_slider release];
    [_bottom release];
    [_timeLabel release];
    [_totalTime release];
    [_playButton release];
    [_dateFormatter release];
    [_videoProgress release];
    [_fullScreenButton release];
    [_player release];
    [_urlStr release];
    [_playerLayer release];
    [self.player removeObserver:self forKeyPath:@"currentItem.status" context:nil];
    [self.player removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player];
    
    [super dealloc];

}


//创建控件
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //设置活跃, 声音才有
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];

        self.backgroundColor = [UIColor blackColor];
        NSURL *movieURL = [NSURL URLWithString:self.urlStr];
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:movieURL];
        self.player = [AVPlayer playerWithPlayerItem:playItem];
        _isSmall = YES;//当前时窗口播放

    }
    return self;
}




- (void)setUrlStr:(NSString *)urlStr {
    if (_urlStr != urlStr) {
        self.slider.value = 0.0000000;
        [MBProgressHUD hideHUDForView:self animated:YES];
        _urlStr = [urlStr copy];
        
    }
    [self.playerLayer removeFromSuperlayer];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
   //监听status属性
    [self.player addObserver:self forKeyPath:@"currentItem.status" options:NSKeyValueObservingOptionNew context:nil];
    //监听loadedTimeRanges属性
    [self.player addObserver:self forKeyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];//设置播放层
    self.playerLayer.frame = self.layer.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.layer addSublayer:self.playerLayer];
    //开始播放
    [self.player play];
    self.bottom.hidden = YES;
    
    //添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemTimeJumpedNotification object:self.player];
    [self.bottom removeFromSuperview];
//    [self layoutSubview];
    
    
    
    
}
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    self.playerLayer.frame = self.bounds;
//    NSLog(@"%@", NSStringFromCGRect(self.bounds));
//    
//}
#pragma mark - 布局子视图
- (void)layoutSubviews  {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    NSLog(@"%@", NSStringFromCGRect(self.frame));

       //灰色视图
    [self.bottom removeFromSuperview];
    self.bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - WIDTH /10, self.bounds.size.width, WIDTH /10)];
    _bottom.backgroundColor = [UIColor grayColor];
//    _bottom.alpha = 0.8;
    _bottom.hidden = YES;
    [self addSubview:self.bottom];
    [_bottom release];
    
    
    //播放暂停按钮
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(WIDTH / 37.5, WIDTH / 70, WIDTH / 12.5, WIDTH / 12.5);
    _playButton.layer.cornerRadius = 15;
    _playButton.clipsToBounds = YES;
    [_playButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.bottom addSubview:self.playButton];
    
    //videoProgress
    
    self.videoProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX( self.playButton.frame) + 10,18, self.bounds.size.width / 3 * 2, 1)];
    _videoProgress.progressViewStyle = UIProgressViewStyleDefault;
    _videoProgress.trackTintColor = [UIColor colorWithRed:0.9699 green:0.9543 blue:0.9851 alpha:1.0];
    _videoProgress.progressTintColor = [UIColor colorWithRed:0.7037 green:0.7037 blue:0.7037 alpha:1.0];
    [self.bottom addSubview:self.videoProgress];
    [_videoProgress release];
    
    //状态条
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame) + 8  , 11, self.bounds.size.width / 3 * 2  + 4, 15)];
    _slider.minimumValue = 0.0;
    _slider.value = 0.0;
    _slider.maximumValue = 1.0;
    //左右轨的图片
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"red"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"slider"];
    [self.slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self.slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.slider setThumbImage:thumbImage forState:UIControlStateNormal];
    _slider.maximumTrackTintColor = [UIColor clearColor];
    [self.bottom addSubview:self.slider];
    [_slider release];
    
    //timeLabel
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.slider.frame) - WIDTH / 6.25, 25, WIDTH / 6.25, WIDTH / 37.5)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor whiteColor];
    [self.bottom addSubview:self.timeLabel];
    [_timeLabel release];
    
    //全屏播放按钮
    
    self.fullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - WIDTH / 10, 5,   WIDTH / 12.5,  WIDTH / 12.5)];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
    [self.fullScreenButton addTarget:self action:@selector(bigOrSmall:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom addSubview:self.fullScreenButton];
    [_fullScreenButton release];

    
    //单击的 Recognizer
    UITapGestureRecognizer *singRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    [self addGestureRecognizer:singRecognizer];
    [singRecognizer release];
    
    
//    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    exitButton.frame = CGRectMake(self.bounds.size.width - 6, -6, 12, 12);
//    [exitButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
//    [exitButton addTarget:self action:@selector(exitView) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:exitButton];
    
    
    //设置菊花
    
//    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    
}

//- (void)exitView {
//    [self.player pause];
//    self.hidden = YES;
//}



#pragma mark - 视频结束时触发的时间

- (void)moviePlayDidEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.slider setValue:0.0 animated:YES];//因为视频马上就要结束了, 将滑块置为0
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }];
}


#pragma mark - KVO 方法 监察者方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //为AVPlayerItem 初始化实例对象
    AVPlayer *avPlayer = (AVPlayer *)object;
    //当监听的是status时
    if ([keyPath isEqualToString:@"currentItem.status"]) {
        //如果准备播放
        if ([avPlayer.currentItem status] == AVPlayerStatusReadyToPlay) {
            //隐藏菊花
            [MBProgressHUD hideHUDForView:self animated:YES];
            self.bottom.hidden = NO;
            CMTime duration = avPlayer.currentItem.duration;//获取视频的总长度
            totalMovelDuration = avPlayer.currentItem.duration.value / avPlayer.currentItem.duration.timescale;//转换成秒
            self.totalTime = [self concertTime:totalMovelDuration];
            [self customVideoSlider:duration];
            [self monitoringPlayback:avPlayer.currentItem];
        }else if ([avPlayer.currentItem status] == AVPlayerStatusFailed) {
            if (!self.alertView) {
                //不一定是网络问题
                self.alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"当前视频无法播放, 请检查你的网络状态或硬件设备" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [self.alertView removeFromSuperview];
            }
            [self.alertView show];
            [_alertView release];
            
            if ([self.delegate respondsToSelector:@selector(AVPlayerStatusFailed:)]) {
                [self.delegate AVPlayerStatusFailed:self];
                
            }
        }
    }else if ([keyPath isEqualToString:@"currentItem.loadedTimeRanges"]) {
        //计算缓存进度
        NSTimeInterval timeinterval = [self availableDuration];
        //计算总时长
        CGFloat totalduration = CMTimeGetSeconds(avPlayer.currentItem.duration);
        [self.videoProgress setProgress:timeinterval / totalduration animated:YES];
    }
}


//转换时间格式的方法
- (NSString *)concertTime:(CGFloat)second {
    //设置显示的内容
    if (second / 3600 >= 1.0) {
        [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    }else {
        [self.dateFormatter setDateFormat:@"mm:ss"];
    }
    //创建NSDate对象
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSString *showTimeNew = [self.dateFormatter stringFromDate:d];
    return showTimeNew;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter ;
}

//自定义slider的外观

- (void)customVideoSlider:(CMTime)durtaion {
    
    
    [self.slider addTarget:self action:@selector(sliderValueWillChange:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderValueChangeEnd:) forControlEvents:UIControlEventTouchCancel];
    
}

#pragma mark ---- 监听播放状态
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = (CGFloat)self.player.currentItem.currentTime.value / self.player.currentItem.currentTime.timescale;//计算当前在第几秒
        self.slider.value = currentSecond / totalMovelDuration;//设置滑块进度
        NSString *timeString = [self  concertTime:currentSecond];//调用转换时间格式的方法
        //为时间显示label 赋值
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", timeString, self.totalTime];
    }];
}

#pragma mark ---- 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    if (loadedTimeRanges.count > 0) {
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        return (startSeconds + durationSeconds);//计算缓冲总进度
    } else {
        return 0.00000;
    }
}

#pragma mark --- 播放按钮的点击事件
- (void)playOrPause {
    if (self.player.rate == 0) {
        [self.player play];//播放
        [self.playButton setImage:[UIImage imageNamed:@"pause1"] forState:UIControlStateNormal];
    } else {
        [self.player pause];//暂停
        [self.playButton setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
    }
}

#pragma mark --- 轻拍手势方法
- (void)handleSingleTapFrom{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.bottom.hidden == NO) {
            self.bottom.hidden = YES;
        } else {
            self.bottom.hidden = NO;
            [self useTimerToHiddenBottom];//定时器隐藏状态条
        }
    } completion:^(BOOL finish){
        
    }];
}

#pragma mark --- 三秒自动隐藏视频状态条
- (void)useTimerToHiddenBottom {
    [self.timer invalidate];
    if (!self.bottom.hidden) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hiddenBottom) userInfo:nil repeats:YES];
    }
}

#pragma mark --- 点击滑块触发的事件
- (void)sliderValueWillChange:(UISlider *)slider {
    [self.player pause];
}

#pragma mark --- 添加当拖动滑块触发的事件
- (void)sliderValueChange:(UISlider *)slider {
    double currentTime = floor(totalMovelDuration * self.slider.value);
    CMTime changedTime = CMTimeMake(currentTime, 1);
    [self.player seekToTime:changedTime completionHandler:^(BOOL finished) {
    }];
}

#pragma mark ---- 添加当拖动结束的事件
- (void)sliderValueChangeEnd:(UISlider *)slider {
    [self.player play];
    [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
}

#pragma mark --- 处理全屏播放界面

- (void)bigOrSmall:(UIButton *)button {
    if (_isSmall) {
        if ([self.delegate respondsToSelector:@selector(turnLeft:)]) {
            [self.delegate turnLeft:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(leftTurnBack:)]) {
            [self.delegate leftTurnBack:self];
        }
    }
    _isSmall = !_isSmall;
}


//定时器触发事件
- (void)hiddenBottom {
    self.bottom.hidden = YES;
}



@end
