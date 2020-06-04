//
//  LXFPhotoViewController.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhotoViewController : UIViewController

- (instancetype)initWithPhotos:(NSArray<PHAsset *> *)photos maxCount:(NSInteger)maxCount;

@property (nonatomic, copy) void (^didSelectedPhoto)(NSArray<PHAsset *> *photos);
@property (nonatomic, copy) void (^didTouchCancelButton)(void);

@end


@interface LXFPhoto_BottomView : UIView

@property (nonatomic, copy) void (^didTouchPreviewButton)(void);
@property (nonatomic, copy) void (^didTouchOkButton)(void);


@end

NS_ASSUME_NONNULL_END
