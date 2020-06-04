//
//  LXFPhoto_Manager.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_Manager.h"

@interface LXFPhoto_Manager()


@end

@implementation LXFPhoto_Manager

+ (LXFPhoto_Manager *)sharedInstance {
    static LXFPhoto_Manager* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.imageRequestOptions = [[PHImageRequestOptions alloc] init];
        sharedInstance.imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        sharedInstance.imageRequestOptions.networkAccessAllowed = YES;
        sharedInstance.imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        sharedInstance.imageRequestOptions.normalizedCropRect = CGRectMake(0.f, 0.f, kLXFScreenWidth/2, kLXFScreenWidth/2);
        sharedInstance.imageRequestOptions.synchronous = YES;
        
        sharedInstance.imageThumRequestOptions = [[PHImageRequestOptions alloc] init];
        sharedInstance.imageThumRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        sharedInstance.imageThumRequestOptions.networkAccessAllowed = YES;
        sharedInstance.imageThumRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        CGFloat imgWidth = (kLXFScreenWidth/4)*UIScreen.mainScreen.scale;
        sharedInstance.imageThumRequestOptions.normalizedCropRect = CGRectMake(0.f, 0.f, imgWidth, imgWidth);
        sharedInstance.imageThumRequestOptions.synchronous = YES;
        
        sharedInstance.imageManager = [[PHCachingImageManager alloc] init];
    });
    return sharedInstance;
}

///获取相册信息
- (void)fetchCamraRollAlbumWithCallback:(void (^)(NSArray<LXFPhoto_Album *> *albums))callback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *groupArrays = [[NSMutableArray alloc] init];

        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (int i=0; i<smartAlbums.count; i++) {
            PHAssetCollection *collection = smartAlbums[i];
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d OR mediaType = %d",PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
//            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            if (assetsFetchResult.count > 0) {
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [groupArrays insertObject:[self albumWithCollection:collection] atIndex:0];
                }else {
                    [groupArrays addObject:[self albumWithCollection:collection]];
                }
            }
        }
        // 列出所有用户创建的相册
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        for (int i=0; i<topLevelUserCollections.count; i++) {
            PHAssetCollection *collection = topLevelUserCollections[i];
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (assetsFetchResult.count > 0) {
                [groupArrays addObject:[self albumWithCollection:collection]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(groupArrays);
            }
        });
    });
}

- (LXFPhoto_Album *)albumWithCollection:(PHAssetCollection *)result{
    LXFPhoto_Album *album = [[LXFPhoto_Album alloc] init];
    album.result = result;
    PHAssetCollection *collection = (PHAssetCollection *)result;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    album.count = [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] + [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo];
    album.name = collection.localizedTitle;

    return album;
}

///获取相册内的所有照片
- (void)fetchAssetsFromAlbum:(LXFPhoto_Album *)album completion:(void (^)(NSArray<PHAsset *> *photos))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHAssetCollection *result = album.result;
        NSMutableArray *photoArr = [NSMutableArray array];
        PHAssetCollection *collection = (PHAssetCollection *)result;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        //            if (asset.mediaType == PHAssetMediaTypeImage || asset.mediaType == PHAssetMediaTypeVideo) {
        //            }
            [photoArr addObject:asset];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(photoArr);
        });
    });
}

///获取单张图片大小
- (void)fetchPhotoBytesWithAsset:(PHAsset *)asset completion:(void (^)(NSString *totalBytes))completion {
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        NSString *bytes = [self getBytesFromDataLength:imageData.length];
        if (completion) {
            completion(bytes);
        }
    }];
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

///获取原图
- (void)fetchOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(NSData *photo, NSDictionary *info))completion {
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:self.imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData,info);
        }
    }];
}

///获取视频路径
- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(NSData *data, NSURL *fileUrl, NSDictionary *info))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(data, url, info);
            });
        }];
    });
}

///判断图片是否为会动的gif
- (BOOL)isActivityGifWithImageData:(NSData *)imageData
{
    uint8_t c;
    
    [imageData getBytes:&c length:1];
    
    if (c == 0x47) {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        size_t imageCount = CGImageSourceGetCount(imageSource);
        if (imageCount > 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

///获取第一帧图片
- (void)fetchFirstImageWithVideoPath:(NSString *)path callback:(void (^)(UIImage *movieImage))callback {
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0, 60);
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    AVAssetImageGeneratorCompletionHandler generatorHandler =
    ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *thumbImg = [UIImage imageWithCGImage:im];
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(thumbImg);
                });
            }
        }
    };
    [generator generateCGImagesAsynchronouslyForTimes:
    [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:generatorHandler];
}

@end
