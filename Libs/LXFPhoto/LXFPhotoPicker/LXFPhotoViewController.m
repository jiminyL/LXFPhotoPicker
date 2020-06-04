//
//  LXFPhotoViewController.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhotoViewController.h"
#import "LXFBrowserViewController.h"
#import "LXFVideoShowViewController.h"

#import "LXFPhoto_Manager.h"

#import "LXFPhoto_ViewModel.h"

#import "LXFPhoto_GP_ContentView.h"
#import "LXFPhoto_AlbumsView.h"

#import "UIView+Toast.h"

@interface LXFPhotoViewController ()

@property (nonatomic, strong) LXFPhoto_ViewModel *vm;

@property (nonatomic, strong) LXFPhoto_GP_ContentView *gridView;
@property (nonatomic, strong) LXFPhoto_BottomView *bottomView;
@property (nonatomic, strong) LXFPhoto_AlbumsView *albumView;

@end

@implementation LXFPhotoViewController

- (instancetype)initWithPhotos:(NSArray<PHAsset *> *)photos maxCount:(NSInteger)maxCount {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.vm.didSelectedArr addObjectsFromArray:photos];
        self.vm.maxCount = maxCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleView];
        
    if ([PHPhotoLibrary respondsToSelector:@selector(authorizationStatus)]) {
        if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fetchAlumbsArr];
            });
        }else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self fetchAlumbsArr];
                    });
                }else if (status == PHAuthorizationStatusDenied) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToast:@"获取相册权限失败，请前往设置，设置相册权限。"];
                    });
                }
            }];
        }
    }
}

#pragma mark - Data
- (void)fetchAlumbsArr {
    @weakify(self)
    [[LXFPhoto_Manager sharedInstance] fetchCamraRollAlbumWithCallback:^(NSArray<LXFPhoto_Album *> * _Nonnull albums) {
        @strongify(self)
        self.vm.albumsArr = albums;
        if (albums.count > 0) {
            self.vm.currentAlbum = albums[0];
        }
        self.gridView.album = self.vm.currentAlbum;
        self.albumView.albumsArr = self.vm.albumsArr;
    }];
}

- (void)viewWillLayoutSubviews {
    [self setupUI];
}

#pragma mark -
- (void)setupUI {
    [self.bottomView setFrame:CGRectMake(0.f, self.view.frame.size.height - (kLXFDevice_Is_iPhoneX ? 70.f : 50.f), self.view.frame.size.width, kLXFDevice_Is_iPhoneX ? 70.f : 50.f)];
    [self.gridView setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - self.bottomView.frame.size.height)];
}

- (void)setupTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 44)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn setFrame:CGRectMake(0.f, 0.f, 60.f, 44.f)];
    [cancelBtn addTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:cancelBtn];
    
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumBtn setTitle:@"选择相册" forState:UIControlStateNormal];
    [albumBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [albumBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [albumBtn setFrame:CGRectMake(0.f, 0.f, 100.f, 44.f)];
    [albumBtn addTarget:self action:@selector(didTouchAlbumButton) forControlEvents:UIControlEventTouchUpInside];
    albumBtn.center = titleView.center;
    [titleView addSubview:albumBtn];
    
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.barTintColor = UIColor.blackColor;
    
}

#pragma mark - Event
- (void)cancelEvent {
    if (self.didTouchCancelButton) {
        self.didTouchCancelButton();
    }
}

- (void)didTouchAlbumButton {    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.albumView.frame.size.height > 0) {
            [self hiddenAlbums];
        }else {
            [self showAlbums];
        }
    });
}

- (void)showAlbums {
    [self.albumView setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    [UIView animateWithDuration:0.35 animations:^{
        [self.albumView setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

- (void)hiddenAlbums {
    [UIView animateWithDuration:0.35 animations:^{
        [self.albumView setFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    }];
}

#pragma mark - MARK
- (LXFPhoto_ViewModel *)vm {
    if (!_vm) {
        _vm = [[LXFPhoto_ViewModel alloc] init];
    }
    return _vm;
}

- (LXFPhoto_GP_ContentView *)gridView {
    if (!_gridView) {
        _gridView = [[LXFPhoto_GP_ContentView alloc] initWithVM:self.vm];
        [_gridView setBackgroundColor:UIColor.blackColor];
        @weakify(self)
        _gridView.didTouchAsset = ^(PHAsset * _Nonnull asset) {
            @strongify(self)
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [LXFPhoto_Manager.sharedInstance fetchOriginalPhotoWithAsset:asset completion:^(NSData * _Nonnull photo, NSDictionary * _Nonnull info) {
                    UIImage *image = [[UIImage alloc] initWithData:photo];
                    [self.navigationController pushViewController:[[LXFBrowserViewController alloc] initWithPhotosArr:@[image] andThumbArr:nil andIndex:0] animated:YES];
                }];
            }else if (asset.mediaType == PHAssetMediaTypeVideo) {
                [LXFPhoto_Manager.sharedInstance fetchVideoWithAsset:asset completion:^(NSData * _Nonnull data, NSURL * _Nonnull fileUrl, NSDictionary * _Nonnull info) {
//                    LXFMediaImage *mediaImage = [[LXFMediaImage alloc] init];
//                    mediaImage.orgData = data;
                    LXFVideoShowViewController *vc = [[LXFVideoShowViewController alloc] init];
                    vc.localVideoUrl = fileUrl;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        };
        [self.view addSubview:_gridView];
    }
    return _gridView;
}

- (LXFPhoto_BottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LXFPhoto_BottomView alloc] init];
        [_bottomView setBackgroundColor:UIColor.blackColor];
        @weakify(self)
        _bottomView.didTouchPreviewButton = ^{
            @strongify(self)
            
        };
        _bottomView.didTouchOkButton = ^{
            @strongify(self)
            if (self.didSelectedPhoto) {
                self.didSelectedPhoto(self.vm.didSelectedArr);
            }
        };
        [self.view addSubview:_bottomView];
    }
    
    return _bottomView;
}


- (LXFPhoto_AlbumsView *)albumView {
    if (!_albumView) {
        _albumView = [[LXFPhoto_AlbumsView alloc] init];
        @weakify(self)
        _albumView.didSeletedAlbum = ^(LXFPhoto_Album * _Nonnull album) {
            @strongify(self)
            [self hiddenAlbums];
            self.vm.currentAlbum = album;
            self.gridView.album = self.vm.currentAlbum;
            self.albumView.albumsArr = self.vm.albumsArr;
        };
        [self.view addSubview:_albumView];
    }
    return _albumView;
}


@end









// ---------------------------------------------------------------------------------------
@interface LXFPhoto_BottomView()

@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation LXFPhoto_BottomView

- (void)layoutSubviews {
    [self.previewButton setFrame:CGRectMake(20.f, 0.f, 100.f, 50.f)];
    [self.okButton setFrame:CGRectMake(self.frame.size.width - 120.f, 0.f, 100.f, 50.f)];
}

#pragma mark - Event
- (void)previewButtonEvent {
    if (self.didTouchPreviewButton) {
        self.didTouchPreviewButton();
    }
}

- (void)okButtonEvent {
    if (self.didTouchOkButton) {
        self.didTouchOkButton();
    }
}

#pragma mark - Lazy
- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_previewButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _previewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_previewButton addTarget:self action:@selector(previewButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_previewButton];
    }
    return _previewButton;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_okButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_okButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        _okButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_okButton addTarget:self action:@selector(okButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okButton];
    }
    return _okButton;
}

@end
