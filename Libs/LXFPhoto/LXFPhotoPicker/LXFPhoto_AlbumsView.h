//
//  LXFPhoto_AlbumsView.h
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFPhoto_Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXFPhoto_AlbumsView : UIView

@property (nonatomic, copy) NSArray<LXFPhoto_Album *> *albumsArr;

@property (nonatomic, copy) void (^didSeletedAlbum)(LXFPhoto_Album *album);

@end

NS_ASSUME_NONNULL_END
