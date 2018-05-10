#import "DWTools.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "sys/utsname.h"

#define CR_COLOR(RED, GREEN, BLUE, ALPHA)    [UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA]

@implementation DWTools

+ (NSInteger)getFileSizeWithPath:(NSString *)filePath Error:(NSError **)error
{
    NSFileManager *fileManager = nil;
    NSDictionary *fileAttr = nil;
    NSInteger fileSize;
    
    fileManager = [NSFileManager defaultManager];
    
    fileAttr = [fileManager attributesOfItemAtPath:filePath error:error];
    if (error && *error) {
        return -1;
    }
    
    fileSize = (NSInteger)[[fileAttr objectForKey:NSFileSize] longLongValue];
    
    return fileSize;
}

+ (UIImage *)getImage:(NSString *)videoPath atTime:(NSTimeInterval)time Error:(NSError **)error
{
    if (!videoPath) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                                                    actualTime:NULL error:error];
    
    logdebug(@"thumbnailImageRef: %p %@", thumbnailImageRef, thumbnailImageRef);
    if (!thumbnailImageRef) {
        return nil;
    }
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    logdebug(@"thumbnailImage: %p", thumbnailImage);
    
    CFRelease(thumbnailImageRef);
    
    return thumbnailImage;
}

+ (BOOL)saveVideoThumbnailWithVideoPath:(NSString *)vieoPath toFile:(NSString *)ThumbnailPath Error:(NSError **)error
{
    NSError *er;
    UIImage *image = [DWTools getImage:vieoPath atTime:1 Error:&er];
    if (er) {
        logerror(@"get video thumbnail failed: %@", [er localizedDescription]);
        if (error) {
            *error = er;
        }
        return NO;
    }
    
    [UIImagePNGRepresentation(image) writeToFile:ThumbnailPath atomically:YES];
    
    logdebug(@"image: %@", image);
    
    return YES;
    
}

+(UIImage *)getThumbnailImage:(NSString *)videoPath time:(NSTimeInterval )time {
    
    if (!videoPath) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 600)
                                                    actualTime:NULL error:nil];
    
    
    if (!thumbnailImageRef) {
        return nil;
    }
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    
    
    CFRelease(thumbnailImageRef);
    
    return thumbnailImage;
    
}

+ (NSString *)formatSecondsToString:(NSInteger)seconds
{
    NSString *hhmmss = nil;
    if (seconds < 0) {
        return @"00:00:00";
    }
    
    int h = (int)round((seconds%86400)/3600);
    int m = (int)round((seconds%3600)/60);
    int s = (int)round(seconds%60);
    
    hhmmss = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    
    return hhmmss;
}
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = heightFactor;
            
        }
        else{
            scaleFactor = widthFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth)/2;
            
        }else if(widthFactor < heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight)/2;
            
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+(CGFloat )fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        long long fileSize =[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        CGFloat floatSize =fileSize/1024.0/1024.0;
        
        return floatSize;
    }
    return 0.0;
}

+(UIImage *)dw_getThumbnailImage:(NSString *)videoPath time:(NSTimeInterval )time {
    
    if (!videoPath) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 600)
                                                    actualTime:NULL error:nil];
    
    
    if (!thumbnailImageRef) {
        return nil;
    }
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    
    
    CFRelease(thumbnailImageRef);
    
    return thumbnailImage;
    
}

//十六进制色彩
+ (UIColor *)colorWithHexString:(NSString *)string{
    
    if (!string) return nil;
    
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return CR_COLOR(((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f), 1);
}


+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat )alpha{
    
    if (!string) return nil;
    
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return CR_COLOR(((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f),alpha);
}

+(double )notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [[NSString stringWithFormat:@"%@",roundedOunces] doubleValue];
}


+ (UIImage *)getThumbnailImageFromVideoURL:(NSURL *)URL time:(NSTimeInterval )videoTime{
    
    if (!URL) return nil;
    
    UIImage *shotImage;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(videoTime, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
}


+ (UIImage *)getThumbnailImageFromFilePath:(NSString *)videoPath time:(NSTimeInterval )videoTime {
    
    if (!videoPath) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = videoTime;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 600)
                                                    actualTime:NULL error:nil];
    
    
    if (!thumbnailImageRef) {
        return nil;
    }
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    
    
    CFRelease(thumbnailImageRef);
    
    return thumbnailImage;
    
}

@end
