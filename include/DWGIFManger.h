//
//  Demo
//
//  Created by luyang on 2017/9/19.
//  Copyright © 2017年 com.bokecc.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

#if TARGET_OS_IPHONE
    #import <MobileCoreServices/MobileCoreServices.h>
    #import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
    #import <CoreServices/CoreServices.h>
    #import <WebKit/WebKit.h>
#endif

typedef NS_ENUM(NSInteger, GIFSize) {
    GIFSizeVeryLow  = 2,
    GIFSizeLow      = 3,
    GIFSizeMedium   = 5,
    GIFSizeHigh     = 7,
    GIFSizeOriginal = 10
};

/**
 
 截取视频
 @param error 错误信息
 @param outPutURL 视频导出的路径
 */
typedef void(^InterceptBlock)(NSError *error,NSURL *outPutURL);

/**
 制作GIF的回调

 @param GifURL GIF的本地URL
 @param error  错误信息
 */
typedef void(^CompleteBlock)(NSError *error,NSURL *GifURL);


@interface DWGIFManger : NSObject

@property (nonatomic,copy)InterceptBlock interceptBlock;

@property (nonatomic,copy)CompleteBlock completeBlock;

//决定GIF图片的分辨率 默认GIFSizeMedium
@property (nonatomic,assign)GIFSize gifSize;



/**
 
 
 @param videoUrl 视频的URL
 @param outPath 输出路径
 @param outputFileType 输出视频格式
 @param videoRange 截取视频的范围
 @param completeBlock 视频截取的回调
 */
- (void)interceptVideoAndVideoUrl:(NSURL *)videoUrl withOutPath:(NSString *)outPath outputFileType:(NSString *)outputFileType range:(NSRange)videoRange intercept:(InterceptBlock)interceptBlock;


/**
 

 @param mediaUrlStr URL字符串
 @return 返回视频时长
 */
- (CGFloat)getMediaDurationWithMediaUrl:(NSString *)mediaUrlStr;


/**
 生成GIF图片
 

 @param videoURL 视频的路径URL
 @param loopCount 播放次数
 @param time 每帧的时间间隔 默认0.25s
 @param imagePath 存放GIF图片的文件路径
 @param completeBlock 完成的回调

 */
- (void)createGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount delayTime:(CGFloat )time gifImagePath:(NSString *)imagePath complete:(CompleteBlock)completeBlock;

/**
 生成GIF图片

 @param videoURL 视频的路径URL
 @param frameCount 视频的总时长乘以固定数值 如：视频总时长*4
 @param time 每帧的时间间隔
 @param loopCount 播放次数
 @param imagePath 存放GIF图片的文件路径
 @param completeBlock 完成的回调
 */
- (void)createGIFfromURL:(NSURL*)videoURL withFrameCount:(int)frameCount delayTime:(CGFloat )time loopCount:(int)loopCount gifImagePath:(NSString *)imagePath complete:(CompleteBlock)completeBlock;

@end
