//
//  PlayerView.m
//  MYPhotos
//
//  Created by zeng on 2021/4/14.
//

#import "PlayerView.h"
#import "YYKitMacro.h"
#import "PlayViewControllView.h"
#import <Masonry/Masonry.h>
#import "NSString+TimeExt.h"
#import "NSString+ext.h"

@interface PlayerView() {
    NSTimer *_playTimer;
}
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) id timeOb;
@property (nonatomic, strong) id playStatusOb;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *rightTimeLabel;

@property (nonatomic, strong) PlayViewControllView *controllView;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) AVPlayerItem *playItem;


@property (nonatomic, assign) BOOL isPanSlider;

@property (nonatomic, assign) NSInteger currentTime;


@end

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControlView)];
    [self addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];


    
    self.avPlayerLayer = [[AVPlayerLayer alloc] init];;
    [self.layer addSublayer:self.avPlayerLayer];
    self.avPlayer = [[AVPlayer alloc] init];

    _controllView= [[PlayViewControllView alloc] init];
    [self addSubview:_controllView];
    UIPanGestureRecognizer *panv = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_controllView addGestureRecognizer:panv];
    
    self.slider = [[UISlider alloc] init];
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    self.slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [_controllView addSubview:self.slider];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.slider addGestureRecognizer:pan];
    
//    self.slider.backgroundColor
    
    _timeLabel= [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [_controllView addSubview:_timeLabel];
    
    
    
    _rightTimeLabel= [[UILabel alloc] init];
    _rightTimeLabel.textColor = [UIColor whiteColor];
    _rightTimeLabel.textAlignment = NSTextAlignmentCenter;
    _rightTimeLabel.font = [UIFont systemFontOfSize:12];
    [_controllView addSubview:_rightTimeLabel];
    
    
    
    _leftButton = [[UIButton alloc] init];
    [_leftButton setTitle:@"-10s" forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(Less:) forControlEvents:UIControlEventTouchUpInside];
    [_controllView addSubview:_leftButton];
    
    
    _rightButton = [[UIButton alloc] init];
    [_rightButton setTitle:@"+10s" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
    [_controllView addSubview:_rightButton];
    
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"zl_playButtonWhite"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"zl_pauseButtonWhite"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [_controllView addSubview:self.playBtn];

    
}

- (void)showControlView {
    [UIView animateWithDuration:0.3 animations:^{
        self->_controllView.alpha = 1;
    }];
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self hiddenControlView];
    }];
}

- (void)hiddenControlView {
    [UIView animateWithDuration:0.3 animations:^{
        self->_controllView.alpha = 0;
    }];
}

- (void)play {
    self.playing = true;
//    if (_timeOb) {
//        [self.avPlayer removeTimeObserver:_timeOb];
//        _timeOb = nil;
//    }
//    @weakify(self);
//    _timeOb = [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
//        @strongify(self);
//        if (!self) return;
//
////        AVPlayerItem *item = self->_avPlayer.currentItem;
////        NSInteger currentTime = self->_avPlayer.currentTime.value/self->_avPlayer.currentTime.timescale;
//        NSTimeInterval ti = CMTimeGetSeconds(self->_avPlayer.currentTime);
//        NSTimeInterval c =  CMTimeGetSeconds(self->_avPlayer.currentItem.duration);
//        NSLog(@"当前播放时间:%f %f",ti, c);
//        self.timeLabel.text = [[NSString stringWithFormat: @"%.0fs", ti ] getMMSSFromSS];
//        self.rightTimeLabel.text = [[NSString stringWithFormat: @"%.0fs", (self.duration - ti) ] getMMSSFromSS];
//        [self updateTime:ti];
//    }];

    _playTimer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self hiddenControlView];
    }];
    if (self.playItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.avPlayer play];
    }
    else {
//        _playTimer =
        [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:false block:^(NSTimer * _Nonnull timer) {
            [self.avPlayer play];
        }];
    }
    
}

- (void)pause {
    self.playing = false;
    [self.avPlayer pause];    
}


- (void)panAction:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            [_playTimer invalidate];
            _isPanSlider = true;
            [self pause];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self pause];
            CGPoint p = [pan locationInView:self.slider];
            if (p.x > self.slider.frame.size.width) {
                break;
            }
            CGFloat percentage = p.x / self.slider.frame.size.width;
            CGFloat delta = percentage * (self.slider.maximumValue - self.slider.minimumValue);
            CGFloat value = self.slider.minimumValue + delta;
            [self.slider setValue:value animated:YES];
            _currentTime = (int)value;
            [self updateleftTime:_currentTime];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            _isPanSlider = false;
            CMTime t = CMTimeMake(_currentTime, 1);
            [self.avPlayer seekToTime:t];
            [self play];
            [self longTapTimer];

            break;
        }
        default:
            break;
    }

    

}

- (void)updateleftTime:(NSTimeInterval)ti {
    self.timeLabel.text = [[NSString stringWithFormat: @"%.0fs", ti ] getMMSSFromSS];
}
- (void)updateTime:(NSTimeInterval)ti {
    if (_isPanSlider) {
        return;
    }
    self.slider.value = ti ;
}


- (void)playAction:(UIButton *)button  {
    if (_playing) {
        [self.avPlayer pause];
    } else {
        [self.avPlayer play];
    }
    self.playing = !_playing;
}

- (void)setPlaying:(BOOL)playing
{
    _playing = playing;
    self.playBtn.selected = playing;
}

- (void)updateProgress:(CGFloat)progress
{
//    self.slider.value = progress;
}
- (void)setVideoUrl:(NSURL *)videoUrl {
    [self cleanPlay];

    
    _videoUrl = videoUrl;
    AVPlayerItem *pitem = [AVPlayerItem playerItemWithURL:videoUrl];
    self.playItem = pitem;
    [self.avPlayer replaceCurrentItemWithPlayerItem:pitem];
    self.avPlayerLayer.player = self.avPlayer;
    self.avPlayerLayer.frame = self.bounds;
    
    self.avPlayer.muted = NO;
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    @weakify(self);
    _timeOb = [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        @strongify(self);
        if (!self) return;
        NSTimeInterval ti = CMTimeGetSeconds(self->_avPlayer.currentTime);
        NSTimeInterval c =  CMTimeGetSeconds(self->_avPlayer.currentItem.duration);
        NSLog(@"当前播放时间:%f %f",ti, c);
        self.timeLabel.text = [[NSString stringWithFormat: @"%.0fs", ti ] getMMSSFromSS];
        self.rightTimeLabel.text = [[NSString stringWithFormat: @"%.0fs", (self.duration - ti) ] getMMSSFromSS];
        [self updateTime:ti];

    }];
}


- (void)setPlayerItem:(AVPlayerItem *)item {
    [self cleanPlay];
    
    self.playItem = item;
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
    self.avPlayerLayer.player = self.avPlayer;
    self.avPlayerLayer.frame = self.bounds;
    
    self.avPlayer.muted = NO;
//    NSInteger currentTime = self.avPlayer.currentItem.currentTime.value/self.avPlayer.currentItem.currentTime.timescale;
//    Float64 seconds = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime);
    [self.avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    self.duration = currentTime;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    
    @weakify(self);
    _timeOb = [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        @strongify(self);
        if (!self) return;
        NSTimeInterval ti = CMTimeGetSeconds(self->_avPlayer.currentTime);
        NSTimeInterval c =  CMTimeGetSeconds(self->_avPlayer.currentItem.duration);
        NSLog(@"当前播放时间:%f %f",ti, c);
        self.timeLabel.text = [[NSString stringWithFormat: @"%.0fs", ti ] getMMSSFromSS];
        self.rightTimeLabel.text = [[NSString stringWithFormat: @"%.0fs", (self.duration - ti) ] getMMSSFromSS];
        [self updateTime:ti];

    }];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            self.duration = [self totalTime];
            self.slider.maximumValue =  self.duration;
            self.slider.value = 0.0;
        } else if (status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayerItemStatusUnknown");
        } else if (status == AVPlayerItemStatusFailed) {
            NSLog(@"AVPlayerItemStatusFailed");
        }

    }
}


// 获取总时间,但是刚开始有可能是Nan,判断下就ok了
// 这个总时间在外面设置的时候基本都是一起刷新UI显示的所以设置个Timer更新显示就行了
- (NSTimeInterval)totalTime {
    CMTime totalTime = self.avPlayer.currentItem.duration;
    NSTimeInterval sec = CMTimeGetSeconds(totalTime);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}


//- (void)setAvPlayer:(AVPlayer *)avPlayer {
//    _avPlayer = avPlayer;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//
//    @weakify(self);
//    _timeOb = [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
//        @strongify(self);
//        if (!self) return;
//
////        AVPlayerItem *item = self->_avPlayer.currentItem;
////        NSInteger currentTime = self->_avPlayer.currentTime.value/self->_avPlayer.currentTime.timescale;
//        NSTimeInterval ti = CMTimeGetSeconds(self->_avPlayer.currentTime);
//        NSTimeInterval c =  CMTimeGetSeconds(self->_avPlayer.currentItem.duration);
//        NSLog(@"当前播放时间:%f %f",ti, c);
//    }];
//
//}


- (void)playFinished
{
    self.playing = false;
    [_avPlayer seekToTime:kCMTimeZero];
    [_avPlayer pause];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
//    int width = self.frame.size.width;
//    int y = frame.size.height - 200;
//    int rx = frame.size.width - 200;
//    int controllViewHeight = width-40;
//    _controllView.frame = CGRectMake(20, y, controllViewHeight, 200);
//    _leftButton.frame = CGRectMake(0, sliderHeight, 200, 150);
//    _rightButton.frame = CGRectMake(rx, sliderHeight, 200, 150);
//    self.playBtn.frame = CGRectMake((controllViewHeight/2) - 80, sliderHeight, 160, 150);
//
//    self.slider.frame = CGRectMake(0, 0, width-40, sliderHeight);
//
//    _leftButton.backgroundColor = [UIColor redColor];
//    _rightButton.backgroundColor = [UIColor orangeColor];
//    _controllView.backgroundColor = [UIColor blueColor];
//    _timeLabel.backgroundColor = [UIColor blueColor];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).with.offset(260); //with is an optional semantic filler
//        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.right.equalTo(self.view.mas_right);
//    }];
    NSNumber *sliderHeight = @44;
    NSNumber *height = @150;
    [_controllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(height);
    }];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_controllView.mas_left).offset(60);
        make.top.equalTo(_controllView.mas_top);
        make.right.equalTo(_controllView.mas_right).offset(-60);
        make.height.equalTo(sliderHeight);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_controllView.mas_left).offset(5);
        make.top.equalTo(_controllView.mas_top);
        make.right.equalTo(_slider.mas_left).offset(-5);
        make.width.equalTo(@50);
        make.height.equalTo(sliderHeight);
    }];
    
    [_rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slider.mas_right).offset(5);
        make.top.equalTo(_controllView.mas_top);
        make.right.equalTo(_controllView.mas_right).offset(-5);
        make.width.equalTo(@50);
        make.height.equalTo(sliderHeight);
    }];
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_controllView.mas_centerX);
        make.top.equalTo(_slider.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playBtn.mas_right);
        make.top.equalTo(_slider.mas_bottom);
        make.right.equalTo(_controllView.mas_right);
        make.height.equalTo(@50);

    }];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_controllView.mas_left);
        make.top.equalTo(_slider.mas_bottom);
        make.right.equalTo(_playBtn.mas_left);
        make.height.equalTo(@50);
    }];
    
}

- (void)Less :(UIButton *)button {
    [self longTapTimer];
//    CMTime currentTime1 = self.avPlayer.currentTime;
//    float currentTime =  self.avPlayer.currentTime .value/ self.avPlayer.currentTime.timescale;
//    CMTime new = CMTimeMake(1, 30);
    [_playTimer invalidate];
    Float64 cur =  CMTimeGetSeconds(self.avPlayer.currentTime);
    cur = cur - 10;
    CMTime new = CMTimeMake(cur, 1);

    [self.avPlayer.currentItem seekToTime:new completionHandler:^(BOOL finished) {
        
    }];
}

- (void)plus :(UIButton *)button {
    [self longTapTimer];
//    CMTime currentTime1 = self.avPlayer.currentTime;
//    float currentTime =  self.avPlayer.currentTime .value/ self.avPlayer.currentTime.timescale;
//    self.avPlayer.currentItem.timebase;
    Float64 cur =  CMTimeGetSeconds(self.avPlayer.currentTime);
    cur = cur + 10;
    CMTime new = CMTimeMake(cur, 1);
    [self.avPlayer.currentItem seekToTime:new completionHandler:^(BOOL finished) {
        
    }];
}

- (void)longTapTimer {
    [_playTimer invalidate];
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self hiddenControlView];
    }];
}

- (void)dismiss {
    
}


//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ( [touch.view isKindOfClass:[PlayViewControllView class]] ) {
//        return NO;
//    }else{
//        return YES;
//    }
//}

- (void)cleanPlay {
    self.playing = false;
    [self.avPlayer pause];
    [_playTimer invalidate];
    if (_timeOb) {
        [self.avPlayer removeTimeObserver:_timeOb];
        _timeOb = nil;
    }
    @try{
        if (self.avPlayer.currentItem) {
            [self.avPlayer.currentItem removeObserver:self forKeyPath:@"status"];
        }        
    }@catch(id anException){
       //do nothing, obviously it wasn't attached because an exception was thrown
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];

}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    return nil;
//}
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    return YES;
//}
@end
