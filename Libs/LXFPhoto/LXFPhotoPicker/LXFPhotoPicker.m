//
//  LXFPhoto.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhotoPicker.h"
#import "LXFPhotoViewController.h"

@interface LXFPhotoPicker()


@end

@implementation LXFPhotoPicker

- (void)showInViewController:(UIViewController *)viewController withPhotos:(nullable NSArray<PHAsset *> *)photos maxCount:(NSInteger)maxCount selectedPhotos:(void (^)(NSArray<PHAsset *> *photos))selectedPhotos{
    LXFPhotoViewController *photoVC = [[LXFPhotoViewController alloc] initWithPhotos:photos maxCount:maxCount];
    photoVC.didSelectedPhoto = ^(NSArray<PHAsset *> * _Nonnull photos) {
        if (selectedPhotos) {
            selectedPhotos(photos);
        }
        [viewController dismissViewControllerAnimated:YES completion:nil];
    };
    photoVC.didTouchCancelButton = ^{
        [viewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoVC];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:navigationController animated:YES completion:nil];
}


@end
