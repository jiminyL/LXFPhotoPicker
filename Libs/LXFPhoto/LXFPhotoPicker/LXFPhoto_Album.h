//
//  LXFPhoto_Album.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

//相册
@interface LXFPhoto_Album : NSObject

@property (nonatomic, strong) NSString *name;        
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) PHAssetCollection *result;
@property (nonatomic) BOOL didSeleted;


@end

NS_ASSUME_NONNULL_END
