//
//  LXFPhoto_GP_GridView.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "LXFPhoto_Manager.h"

#import "LXFPhoto_ViewModel.h"

@class LXFPhoto_GP_GridCell;

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhoto_GP_GridView : UIView

- (instancetype)initWithVM:(LXFPhoto_ViewModel *)vm;

@property (nonatomic, strong) LXFPhoto_Album *album;

@property (nonatomic, copy) void (^didTouchSelecteButton)(LXFPhoto_GP_GridCell *cell);
@property (nonatomic, copy) void (^didTouchAsset)(PHAsset *asset);

@end

NS_ASSUME_NONNULL_END
