//
//  LXFPhoto_ViewModel.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_ViewModel.h"

@implementation LXFPhoto_ViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.maxCount = 4;
    }
    return self;
}

- (void)setCurrentAlbum:(LXFPhoto_Album *)currentAlbum {
    _currentAlbum = currentAlbum;
    
    for (LXFPhoto_Album *tempAlbum in self.albumsArr) {
        tempAlbum.didSeleted = tempAlbum == currentAlbum;
    }
}

- (void)removePHAsset:(PHAsset *)asset {
    if ([self.didSelectedArr containsObject:asset]) {
        [self.didSelectedArr removeObject:asset];
    }
}

- (void)addPHAsset:(PHAsset *)asset {
    if (![self.didSelectedArr containsObject:asset]) {
        [self.didSelectedArr addObject:asset];
    }
}

- (NSMutableArray<PHAsset *> *)didSelectedArr {
    if (!_didSelectedArr) {
        _didSelectedArr = [[NSMutableArray alloc] init];
    }
    return _didSelectedArr;
}

@end
