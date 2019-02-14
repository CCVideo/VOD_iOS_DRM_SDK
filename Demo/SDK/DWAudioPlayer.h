//

//  LYPlayer
//
//  Created by luyang on 2017/10/10.
//  Copyright © 2017年 Myself. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class DWAudioPlayer;

@protocol DWAudioPlayerDelegate <NSObject>

@optional

/*
 *
 *AVPlayerItem的三种状态
 *AVPlayerItemStatusUnknown,
 *AVPlayerItemStatusReadyToPlay,
 *AVPlayerItemStatusFailed
 */

//所有的代理方法均已回到主线程
// 可播放／播放中
- (void)audioPlayerIsReadyToPlayVideo:(DWAudioPlayer *)audioPlayer;
//播放完毕
- (void)audioPlayerDidReachEnd:(DWAudioPlayer *)audioPlayer;
//当前播放时间
- (void)audioPlayer:(DWAudioPlayer *)audioPlayer timeDidChange:(CGFloat )time;
//duration 当前缓冲的长度
- (void)audioPlayer:(DWAudioPlayer *)audioPlayer loadedTimeRangeDidChange:(CGFloat )duration;
//进行跳转后没数据 即播放卡顿
- (void)audioPlayerPlaybackBufferEmpty:(DWAudioPlayer *)audioPlayer;
// 进行跳转后有数据 能够继续播放
- (void)audioPlayerPlaybackLikelyToKeepUp:(DWAudioPlayer *)audioPlayer;
//加载失败
- (void)audioPlayer:(DWAudioPlayer *)audioPlayer didFailWithError:(NSError *)error;

@end


@interface DWAudioPlayer : NSObject



//播放时为YES 暂停时为NO
@property (nonatomic, assign,readonly) BOOL isAudioPlaying;

//播放属性
@property (nonatomic, strong,readonly) AVPlayer      *player;
@property (nonatomic, strong,readonly) AVPlayerItem  *item;
@property (nonatomic, strong,readonly) AVURLAsset    *urlAsset;




@property (nonatomic,weak) id<DWAudioPlayerDelegate> delegate;

//单例
+ (instancetype)sharedInstance;

//设置播放URL
- (void)setAudioURL:(NSURL *)URL;
/*
 *scrub:方法 在AVPlayerItemStatusReadyToPlay即状态处于可播放后 才会有效果
 */
//跳到xx秒播放音频
- (void)audioScrub:(CGFloat )time;

//播放
- (void)audioPlay;

//暂停
- (void)audioPause;
//重播
- (void)audioRepeatPlay;

//停止播放
- (void)audioResetPlayer;

//设置播放倍速 0.5-2.0
- (void)setAudioPlayerRate:(CGFloat )rate;

//获取当前播放的时间
- (CGFloat )getCurrentPlayTime;

//获取总时间长
- (CGFloat)getTotalPlayTime;

@end
