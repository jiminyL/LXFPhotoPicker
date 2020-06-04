//
//  LXFPhoto_AlbumsView.m
//  LXFPhotoPicker
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "LXFPhoto_AlbumsView.h"

#import "LXFPhoto_AlbumTableViewCell.h"

@interface LXFPhoto_AlbumsView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LXFPhoto_AlbumsView

- (void)setAlbumsArr:(NSArray<LXFPhoto_Album *> *)albumsArr {
    _albumsArr = albumsArr;
    
    [self.tableView reloadData];
}

- (void)layoutSubviews {
    [self setupUI];
}

- (void)setupUI {
    [self.bgView setFrame:CGRectMake(0.f, 0.f, kLXFScreenWidth, kLXFScreenHeight)];

    [UIView animateWithDuration:0.35 animations:^{
        if (self.frame.size.height == 0) {
            [self.bgView setAlpha:0];
        }else {
            [self.bgView setAlpha:0.3];
        }
        
        [self.tableView setFrame:CGRectMake(0.f, 0.f, kLXFScreenWidth, self.frame.size.height * 0.6)];
        [self bringSubviewToFront:self.tableView];
    }];
}

#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LXFPhoto_AlbumTableViewCell *cell = (LXFPhoto_AlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LXFPhoto_AlbumTableViewCellIdentifier" forIndexPath:indexPath];
    cell.album = self.albumsArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.albumsArr.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSeletedAlbum) {
        self.didSeletedAlbum(self.albumsArr[indexPath.row]);
    }
}

#pragma mark - Lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:UIColor.blackColor];
        [_bgView setAlpha:0.3];
        [_bgView setClipsToBounds:YES];
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, kLXFScreenWidth, 0.f) style:UITableViewStylePlain];
        [_tableView registerClass:LXFPhoto_AlbumTableViewCell.class forCellReuseIdentifier:@"LXFPhoto_AlbumTableViewCellIdentifier"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setClipsToBounds:YES];
        [self addSubview:_tableView];
    }
    
    return _tableView;
}

@end
