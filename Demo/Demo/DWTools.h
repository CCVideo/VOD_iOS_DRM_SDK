#import <Foundation/Foundation.h>

@interface DWTools : NSObject

+ (NSInteger)getFileSizeWithPath:(NSString *)filePath Error:(NSError **)error;

+ (UIImage *)getImage:(NSString *)videoPath atTime:(NSTimeInterval)time Error:(NSError **)error;

+ (BOOL)saveVideoThumbnailWithVideoPath:(NSString *)vieoPath toFile:(NSString *)ThumbnailPath Error:(NSError **)error;

+ (NSString *)formatSecondsToString:(NSInteger)seconds;
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//获取文件大小
+(CGFloat )fileSizeAtPath:(NSString*) filePath;

//十六进制色彩
+ (UIColor *)colorWithHexString:(NSString *)string;

+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat )alpha;

+(double )notRounding:(float)price afterPoint:(int)position;

//获取缩略图
+(UIImage *)getThumbnailImage:(NSString *)videoPath time:(NSTimeInterval )time;

//获取网络视频的缩略图
+ (UIImage *)getThumbnailImageFromVideoURL:(NSURL *)URL time:(NSTimeInterval )videoTime;
//获取本地视频缩略图
+ (UIImage *)getThumbnailImageFromFilePath:(NSString *)videoPath time:(NSTimeInterval )videoTime;

+ (NSMutableAttributedString *)exchangeString:(NSString *)string withText:(NSString *)text imageName:(NSString *)imageName;

@end
