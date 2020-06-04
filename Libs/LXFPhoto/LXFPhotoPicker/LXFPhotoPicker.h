//
//  LXFPhoto.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "LXFPhoto_Manager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhotoPicker : NSObject

- (void)showInViewController:(UIViewController *)viewController withPhotos:(NSArray<PHAsset *> *)photos maxCount:(NSInteger)maxCount selectedPhotos:(void (^)(NSArray<PHAsset *> *photos))selectedPhotos;

@end

NS_ASSUME_NONNULL_END
