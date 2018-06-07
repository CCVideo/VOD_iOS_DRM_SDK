#import <UIKit/UIKit.h>
#import "DWSDK.h"

@interface DWCustomPlayerViewController : UIViewController

@property (copy, nonatomic)NSString *videoId;
@property (copy, nonatomic)NSString *localPath;
@property (assign, nonatomic)BOOL playMode;
@property (strong, nonatomic)NSArray *videos;
@property (assign, nonatomic)NSInteger indexpath;

@property (nonatomic,copy)NSArray *localArray;//本地播放数组

+ (instancetype)sharedInstance;

@end
