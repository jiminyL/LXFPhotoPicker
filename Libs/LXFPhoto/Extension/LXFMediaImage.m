//
//  LXFMediaImage.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/22.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFMediaImage.h"

#import "LXFFileManager.h"

@implementation LXFMediaImage

- (NSData *)orgData {
    if (_orgData) {
        return _orgData;
    }
    return [LXFFileManager fetchImageDataWithImageName:self.videoId];
//    if (!_orgData) {
//        _orgData = [LXFFileManager fetchImageDataWithImageName:strOrEmpty(self.videoId)];
//    }
//    return _orgData;
}

@end
