//
//  LXFPhoto_GP_ContentView.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_GP_ContentView.h"

#import "LXFPhoto_GP_GridView.h"

#import "LXFPhoto_GP_GridCell.h"

#import "UIView+Toast.h"

@interface LXFPhoto_GP_ContentView()

@property (nonatomic, strong) LXFPhoto_GP_GridView *gridView;

@property (nonatomic, weak) LXFPhoto_ViewModel *vm;

@end

@implementation LXFPhoto_GP_ContentView

- (instancetype)initWithVM:(LXFPhoto_ViewModel *)vm {
    if (self = [super init]) {
        self.vm = vm;
    }
    return self;
}

- (void)setAlbum:(LXFPhoto_Album *)album {
    _album = album;
    
    [self makeToastActivity];
    self.gridView.album = album;
    [self hideToastActivity];
}

- (void)layoutSubviews {
    [self setupUI];
}

- (void)setupUI {
    [self.gridView setFrame:self.bounds];
}

#pragma mark - Lazy
- (LXFPhoto_GP_GridView *)gridView {
    if (!_gridView) {
        _gridView = [[LXFPhoto_GP_GridView alloc] initWithVM:self.vm];
        [_gridView setBackgroundColor:UIColor.redColor];
        @weakify(self)
        _gridView.didTouchSelecteButton = ^(LXFPhoto_GP_GridCell * _Nonnull cell) {
            @strongify(self)
            if (cell.didSeleted) {
                //删除
                cell.didSeleted = !cell.didSeleted;
                [self.vm removePHAsset:cell.asset];
            }else {
                //新增
                if (self.vm.didSelectedArr.count < self.vm.maxCount) {
                    if (cell.asset.mediaType == PHAssetMediaTypeImage) {
                        //图片
                        cell.didSeleted = !cell.didSeleted;
                        [self.vm addPHAsset:cell.asset];
                    }else if (cell.asset.mediaType == PHAssetMediaTypeVideo) {
                        //视频
                        [LXFPhoto_Manager.sharedInstance fetchVideoWithAsset:cell.asset completion:^(NSData * _Nonnull data, NSURL * _Nonnull fileUrl, NSDictionary * _Nonnull info) {
                            CGFloat dataSize = data.length / 1024 / 1024;
                            if (dataSize < 20) {
                                cell.didSeleted = !cell.didSeleted;
                                [self.vm addPHAsset:cell.asset];
                            }else {
                                [self makeToast:@"选择的视频不得大于20M"];
                            }
                        }];
                    }
                }else {
                    //超出最多选择数
                    [self makeToast:[NSString stringWithFormat:@"最多选择%ld张图片或视频", self.vm.maxCount]];
                }
            }
        };
        _gridView.didTouchAsset = ^(PHAsset * _Nonnull asset) {
            @strongify(self)
            if (self.didTouchAsset) {
                self.didTouchAsset(asset);
            }
        };
        [self addSubview:_gridView];
    }
    return _gridView;
}



@end
