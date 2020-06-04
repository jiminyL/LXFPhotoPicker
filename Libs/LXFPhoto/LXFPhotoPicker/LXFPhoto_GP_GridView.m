//
//  LXFPhoto_GP_GridView.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_GP_GridView.h"

#import "LXFPhoto_GP_GridCell.h"

#import "LXFPhoto_Macro.h"

@interface LXFPhoto_GP_GridView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LXFPhoto_ViewModel *vm;

@property (nonatomic, strong) PHFetchResult *fetchResult;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) BOOL shouldToScrollToBottom;


@end

@implementation LXFPhoto_GP_GridView

- (instancetype)initWithVM:(LXFPhoto_ViewModel *)vm {
    if (self = [super init]) {
        self.vm = vm;
        self.shouldToScrollToBottom = YES;
    }
    return self;
}

- (void)setAlbum:(LXFPhoto_Album *)album {
    _album = album;
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d OR mediaType = %d",PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
//    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.album.result options:options];
    
    [self setupUI];
    
    [self scrollToBottom];    
}

- (void)layoutSubviews {
    [self setupUI];
}

- (void)setupUI {
    [self.collectionView reloadData];
    [self.collectionView setFrame:self.bounds];
}

#pragma mark - Function
- (void)scrollToBottom {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.fetchResult.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXFPhoto_GP_GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXFPhoto_GP_GridCellIdentifier" forIndexPath:indexPath];
    cell.asset = self.fetchResult[indexPath.item];
    cell.didSeleted = [self.vm.didSelectedArr containsObject:cell.asset];
    @weakify(self)
    cell.didTouchSelecteButton = ^(LXFPhoto_GP_GridCell * _Nonnull cell) {
        @strongify(self)

        if (self.didTouchSelecteButton) {
            self.didTouchSelecteButton(cell);
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = kLXFScreenWidth / 4;
    return CGSizeMake(width, width);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    PHAsset *asset = self.fetchResult[indexPath.item];
    
    if (self.didTouchAsset) {
        self.didTouchAsset(asset);
    }
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat width = kLXFScreenWidth / 4;
        flowLayout.itemSize = CGSizeMake(width, width);

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:LXFPhoto_GP_GridCell.class forCellWithReuseIdentifier:@"LXFPhoto_GP_GridCellIdentifier"];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}


@end
