//
//  LXFPhoto_Manager.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LXFPhoto_Album.h"
#import "LXFPhoto_Macro.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhoto_Manager : NSObject

+ (LXFPhoto_Manager *)sharedInstance;

///获取相册信息
- (void)fetchCamraRollAlbumWithCallback:(void (^)(NSArray<LXFPhoto_Album *> *albums))callback;

///获取相册内的所有照片
- (void)fetchAssetsFromAlbum:(LXFPhoto_Album *)album completion:(void (^)(NSArray<PHAsset *> *photos))completion;

///获取单张图片大小
- (void)fetchPhotoBytesWithAsset:(PHAsset *)asset completion:(void (^)(NSString *totalBytes))completion;

///获取原图
- (void)fetchOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(NSData *photo, NSDictionary *info))completion;

///获取视频路径
- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(NSData *data, NSURL *fileUrl, NSDictionary *info))completion;

///判断图片是否为会动的gif
- (BOOL)isActivityGifWithImageData:(NSData *)imageData;

///获取第一帧图片
- (void)fetchFirstImageWithVideoPath:(NSString *)path callback:(void (^)(UIImage *movieImage))callback;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *imageRequestOptions;
@property (nonatomic, strong) PHImageRequestOptions *imageThumRequestOptions;

@end

NS_ASSUME_NONNULL_END
