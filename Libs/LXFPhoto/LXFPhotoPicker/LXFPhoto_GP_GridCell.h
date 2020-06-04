//
//  LXFPhoto_GP_GridCell.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFPhoto_Manager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhoto_GP_GridCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic) BOOL didSeleted;

@property (nonatomic, copy) void (^didTouchSelecteButton)(LXFPhoto_GP_GridCell *cell);

@end

NS_ASSUME_NONNULL_END
