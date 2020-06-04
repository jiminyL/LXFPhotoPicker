//
//  LXFPhoto_GP_ContentView.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFPhoto_Manager.h"
#import "LXFPhoto_ViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhoto_GP_ContentView : UIView

@property (nonatomic, strong) LXFPhoto_Album *album;

- (instancetype)initWithVM:(LXFPhoto_ViewModel *)vm;

@property (nonatomic, copy) void (^didAddAsset)(PHAsset *asset);
@property (nonatomic, copy) void (^didRemoveAsset)(PHAsset *asset);
@property (nonatomic, copy) void (^didTouchAsset)(PHAsset *asset);

@end

NS_ASSUME_NONNULL_END
