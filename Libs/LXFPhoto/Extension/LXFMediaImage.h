//
//  LXFMediaImage.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXFMediaImage : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, nullable) NSData *orgData;
@property (nonatomic, strong) UIImage *thumb;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic) CGFloat videoTime;

@property (nonatomic, strong) PHAsset *asset;           //从相册获取

@end

NS_ASSUME_NONNULL_END
