//
//  PlayerView.h
//  MYPhotos
//
//  Created by zeng on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIView

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL playing;

- (void)setVideoUrl:(NSURL *)videoUrl;
- (void)setPlayerItem:(AVPlayerItem *)item;

- (void)play;
- (void)pause;

- (void)cleanPlay;

@end

NS_ASSUME_NONNULL_END
