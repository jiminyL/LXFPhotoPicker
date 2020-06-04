//
//  LXFPhoto_ViewModel.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXFPhoto_manager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhoto_ViewModel : NSObject

@property (nonatomic) NSInteger maxCount;

@property (nonatomic, copy) NSArray<LXFPhoto_Album *> *albumsArr;
@property (nonatomic, strong) LXFPhoto_Album *currentAlbum;

@property (nonatomic, strong) NSMutableArray<PHAsset *> *didSelectedArr;
- (void)removePHAsset:(PHAsset *)asset;
- (void)addPHAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
