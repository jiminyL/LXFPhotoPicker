//
//  LXFPhoto_GP_GridCell.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_GP_GridCell.h"

@interface LXFPhoto_GP_GridCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selecteButton;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation LXFPhoto_GP_GridCell

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    CGFloat width = (self.frame.size.width) * [UIScreen mainScreen].scale;
    [LXFPhoto_Manager sharedInstance].imageThumRequestOptions.normalizedCropRect = CGRectMake(0.f, 0.f, width, width);
    [[LXFPhoto_Manager sharedInstance].imageManager requestImageForAsset:_asset targetSize:CGSizeMake(width, width) contentMode:PHImageContentModeAspectFill options:[LXFPhoto_Manager sharedInstance].imageThumRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
    }];
    
    if (_asset.mediaType == PHAssetMediaTypeVideo) {
        //视频
        [self.descLabel setHidden:NO];
        [self.descLabel setText:[NSString stringWithFormat:@"视频 %@", [self secondFormat:_asset.duration]]];
    }else {
        [self.descLabel setHidden:YES];
    }
}

- (void)setDidSeleted:(BOOL)didSeleted {
    _didSeleted = didSeleted;
    
    [self.selecteButton setImage:didSeleted ? [UIImage imageNamed:@"LXFPH_Selected.png"] : [UIImage imageNamed:@"LXFPH_UnSeleted.png"] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    
    [self setupUI];
    
}

- (void)setupUI {
    
    [self.imageView setFrame:CGRectMake(1.f, 1.f, self.contentView.frame.size.width - 1.f, self.contentView.frame.size.height - 1.f)];
    
    CGFloat selecteWidth = self.contentView.frame.size.width/3;
    [self.selecteButton setFrame:CGRectMake(self.contentView.frame.size.width - selecteWidth, 0.f, selecteWidth, selecteWidth)];
    
    [self.descLabel setFrame:CGRectMake(5.f, self.contentView.frame.size.height - 17.f, self.contentView.frame.size.width - 10.f, 15.f)];
}

#pragma mark - Event
- (void)selecteButtonEvent {
    
    if (self.didTouchSelecteButton) {
        self.didTouchSelecteButton(self);
    }
}

#pragma mark - Lazy
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    return  _imageView;
}

- (UIButton *)selecteButton {
    if (!_selecteButton) {
        _selecteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selecteButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selecteButton addTarget:self action:@selector(selecteButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selecteButton];
    }
    return _selecteButton;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:UIColor.whiteColor];
        [_descLabel setFont:[UIFont systemFontOfSize:11]];
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}

- (NSString *)secondFormat:(NSTimeInterval)duration {
    NSInteger minute = duration/60;
    NSInteger second = duration - (minute*60);
    
    NSString *secondStr;
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%ld", second];
    }else {
        secondStr = [NSString stringWithFormat:@"%ld", second];
    }
    return [NSString stringWithFormat:@"%ld:%@", minute, secondStr];
}

@end
