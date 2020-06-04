//
//  LXFPhoto_AlbumTableViewCell.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_AlbumTableViewCell.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface LXFPhoto_AlbumTableViewCell()

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *groupTitleLabel;
@property (nonatomic, strong) UIImageView *selectedIV;

@end

@implementation LXFPhoto_AlbumTableViewCell

- (void)setAlbum:(LXFPhoto_Album *)album {
    _album = album;
    
    //缩略图
    PHAssetCollection *collection = (PHAssetCollection *)album.result;
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d OR mediaType = %d",PHAssetMediaTypeImage, PHAssetMediaTypeVideo];

    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    if (assetsFetchResult.count > 0) {
        PHAsset *asset = assetsFetchResult[assetsFetchResult.count - 1];
        [[LXFPhoto_Manager sharedInstance].imageManager requestImageForAsset:asset
                                                           targetSize:CGSizeMake(kScreenWidth/2, kScreenWidth/2)
                                                          contentMode:PHImageContentModeAspectFill
                                                              options:[LXFPhoto_Manager sharedInstance].imageRequestOptions
                                                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                            [self.thumbImageView setImage:result];
                                                        }];
    }else {
        [self.thumbImageView setImage:[UIImage imageNamed:@"LXFP_Default.png"]];
    }
    
    //title
    [self.groupTitleLabel setText:[NSString stringWithFormat:@"%@(%d)", album.name, (int)album.count]];
    
    [self.selectedIV setHidden:!self.album.didSeleted];
    
    [self setupUI];
}

- (void)layoutSubviews {
    [self setupUI];
}

- (void)setupUI {
    
    CGFloat offsetX = 0.f;
    [self.thumbImageView setFrame:CGRectMake(offsetX, 0.f, self.contentView.frame.size.height, self.contentView.frame.size.height)];
    offsetX += (_thumbImageView.frame.size.width + 10.f);
    [self.groupTitleLabel setFrame:CGRectMake(offsetX, 0.f, self.contentView.frame.size.width - offsetX - 10.f, self.contentView.frame.size.height)];
    
    [self.selectedIV setFrame:CGRectMake(self.contentView.frame.size.width - 30.f, (self.contentView.frame.size.height - 11)/2, 15.f, 11.f)];
}

#pragma mark - Lazy
- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_thumbImageView];
    }
    
    return _thumbImageView;
}

- (UILabel *)groupTitleLabel {
    if (!_groupTitleLabel) {
        _groupTitleLabel = [[UILabel alloc] init];
        [_groupTitleLabel setTextColor:[UIColor blackColor]];
        [_groupTitleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [self.contentView addSubview:_groupTitleLabel];
    }
    return _groupTitleLabel;
}

- (UIImageView *)selectedIV {
    if (!_selectedIV) {
        _selectedIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_icon_red_nike"]];
        [self.contentView addSubview:_selectedIV];
    }
    return _selectedIV;
}



@end
