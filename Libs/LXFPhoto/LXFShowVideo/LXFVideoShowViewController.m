//
//  LXFVideoShowViewController.m
//  iBuilding
//
//  Created by 梁啸峰 on 2020/4/22.
//

#import "LXFVideoShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LXFFileManager.h"

@interface LXFVideoShowViewController ()

@property (nonatomic, strong) LXFMediaImage *mediaImage;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;

@property (nonatomic) BOOL shouldToRemoveNotification;

@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation LXFVideoShowViewController

- (instancetype)initWithMediaImage:(LXFMediaImage *)mediaImage {
    if (self = [super init]) {
        self.mediaImage = mediaImage;
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = 0;
        
        if (mediaImage.orgData) {
            if ([LXFFileManager saveTempVideoDataToCache:mediaImage.orgData]) {
                NSString *filePath = [LXFFileManager fetchTempVideoFilePath];
                if (filePath) {
                    self.localVideoUrl = [NSURL fileURLWithPath:filePath];
                }
            }
        }else {
            NSData *data = [LXFFileManager fetchImageDataWithImageName:mediaImage.videoUrl];
            
            if (data) {
                self.localVideoUrl = [NSURL fileURLWithPath:[LXFFileManager fetchImageFileUrlWithImageName:mediaImage.videoUrl]];
            }else {
                //TODO 下载
//                [[APICooperationInfo sharedInstance] fetchPhotoWithPath:mediaImage.videoUrl process:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//                    CGFloat progess = (CGFloat)((CGFloat)totalBytesRead / totalBytesExpectedToRead);
//                    NSInteger progressInt = progess*100;
//                    NSString *str = [NSString stringWithFormat:@"%d%@", (int)progressInt, @"%"];
//                    [self.progressLabel setText:str];
//                    [self.progressLabel setFrame:CGRectMake((self.view.width - 100.f)/2, self.view.height / 2, 100.f, 50.f)];
//                    [self.progressLabel setHidden:NO];
//                } andCallback:^(BOOL success, id message, id responseObject) {
//                    [self.progressLabel setHidden:YES];
//                    if ([LXFFileManager saveImageWithImageData:responseObject andName:mediaImage.videoUrl]) {
//                        NSString *fileStr = [LXFFileManager fetchImageFileUrlWithImageName:mediaImage.videoUrl];
//                        self.localVideoUrl = [NSURL fileURLWithPath:fileStr];
//                    }else {
//                        [self.view makeToast:@"下载视频失败"];
//                    }
//                }];
            }
        }
    }
    return self;
}

- (void)dealloc {
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    [self.view addGestureRecognizer:tap1];
}

- (void)setLocalVideoUrl:(NSURL *)localVideoUrl {
    _localVideoUrl = localVideoUrl;
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:_localVideoUrl];
        
    self.player = [AVPlayer playerWithPlayerItem:item];
        
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
        
    [self.player play];
    self.isPlay = YES;
        
    [self addNotification];
}

#pragma mark - Event
- (void)singleTap {
    [self.navigationController popViewControllerAnimated:YES];
}

//循环播放
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    self.shouldToRemoveNotification = YES;
}

-(void)removeNotification{
    if (self.shouldToRemoveNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

#pragma mark - Lazy
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        [_progressLabel setTextColor:[UIColor whiteColor]];
        [_progressLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_progressLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:_progressLabel];
    }
    return _progressLabel;
}



@end
