//
//  LXFBrowserCollectionViewCell.m
//  KDSLife
//
//  Created by PChome on 2017/3/22.
//
//

#import "LXFBrowserCollectionViewCell.h"

#import "DACircularProgressView.h"

#import <Photos/Photos.h>

#import "LXFFileManager.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

#import "UIView+Layout.h"

@interface LXFBrowserCollectionViewCell()<UIGestureRecognizerDelegate,UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YLImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, strong) DACircularProgressView *progress;
@property (nonatomic, strong) UIImageView *errImageView;

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *thumbStr;

@property (nonatomic) BOOL canLongPress;
@property (nonatomic) BOOL canDoubleTap;

@property (nonatomic) UIImage *image;

@end

@implementation LXFBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canLongPress = YES;
        
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self.contentView addSubview:_scrollView];
        
        self.imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[YLImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        // Loading indicator
        self.progress = [[DACircularProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width - 40.f)/2, (self.frame.size.height - 40.f)/2, 40.0f, 40.0f)];
        self.progress.userInteractionEnabled = NO;
        self.progress.thicknessRatio = 0.1;
        self.progress.roundedCorners = NO;
        self.progress.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:self.progress];

        self.errImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageError.png"]];
        [self.errImageView setFrame:CGRectMake((self.frame.size.width - 40.f)/2, (self.frame.size.height - 40.f)/2, 40.0f, 40.0f)];
        self.errImageView.hidden = YES;
        [self.contentView addSubview:self.errImageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.canLongPress = NO;
    self.canDoubleTap = NO;
    
    self.errImageView.hidden = YES;
    
    [_scrollView setZoomScale:1.f animated:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *thumbData = UIImageJPEGRepresentation(image, 1.f);
        if (thumbData) {
            YLGIFImage *thumbImage = (YLGIFImage *)[YLGIFImage imageWithData:thumbData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageView setImage:thumbImage];
                [self resizeSubviews];
            });
        }
        
        NSData *data = UIImageJPEGRepresentation(image, 1.f);
        if (data) {
            YLGIFImage *image = (YLGIFImage *)[YLGIFImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errImageView.hidden = YES;
                [self.imageView setImage:image];
                self.progress.hidden = YES;
                self.canLongPress = YES;
                self.canDoubleTap = YES;
                [self resizeSubviews];
            });
        }
    });
}

- (void)setUrlStr:(NSString *)urlStr andThumbStr:(NSString *)thumbStr
{
    self.canLongPress = NO;
    self.canDoubleTap = NO;
    
    self.urlStr = urlStr;
    self.thumbStr = thumbStr;
    
    self.errImageView.hidden = YES;
    
    [_scrollView setZoomScale:1.f animated:NO];
    NSData *thumbData = [LXFFileManager fetchImageDataWithImageName:thumbStr];
    if (thumbData) {
        YLGIFImage *thumbImage = (YLGIFImage *)[YLGIFImage imageWithData:thumbData];
        [self.imageView setImage:thumbImage];
        [self resizeSubviews];
    }

    NSData *data = [LXFFileManager fetchImageDataWithImageName:urlStr];
    if (data) {
        self.errImageView.hidden = YES;
        YLGIFImage *image = (YLGIFImage *)[YLGIFImage imageWithData:data];
        [self.imageView setImage:image];
        
        self.progress.hidden = YES;
        self.canLongPress = YES;
        self.canDoubleTap = YES;
        [self resizeSubviews];
    }else {
        self.progress.hidden = NO;
        self.progress.trackTintColor = [UIColor yellowColor];
//        [[APICooperationInfo sharedInstance] fetchPhotoWithPath:strOrEmpty(urlStr) process:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//            self.progress.hidden = NO;
//            [self.imageContainerView bringSubviewToFront:self.progress];
//            self.progress.progress = (CGFloat)((CGFloat)totalBytesRead / totalBytesExpectedToRead);
//        } andCallback:^(BOOL success, id message, id responseObject) {
//            self.progress.hidden = YES;
//            if ([responseObject isKindOfClass:[NSData class]]) {
//                self.errImageView.hidden = YES;
//                NSData *resData = (NSData *)responseObject;
//                [LXFFileManager saveImageWithImageData:resData andName:urlStr];
//                YLGIFImage *image = (YLGIFImage *)[YLGIFImage imageWithData:resData];
//                [self.imageView setImage:image];
//
//                self.canLongPress = YES;
//                self.canDoubleTap = YES;
//
//                [self resizeSubviews];
//            }else {
//                self.errImageView.hidden = NO;
//            }
//        }];
    }
}

- (void)resizeSubviews {
    _imageContainerView.tz_origin = CGPointZero;
    _imageContainerView.tz_width = self.tz_width;

    YLGIFImage *image = (YLGIFImage *)_imageView.image;

    if ((image.size.height / image.size.width) > (self.tz_height / self.tz_width)) {
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.tz_width));
    }else {
        CGFloat height = image.size.height / image.size.width * self.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (_imageContainerView.tz_height > self.tz_height && _imageContainerView.tz_height - self.tz_height <= 1) {
        _imageContainerView.tz_height = self.tz_height;
    }
    if ((image.size.height / image.size.width) >= 1) {
        //竖的图片
        self.scrollView.maximumZoomScale = floor(self.tz_width / _imageContainerView.tz_width) > 2.5f ? floor(self.tz_width / _imageContainerView.tz_width) : 2.5f;
    }else {
        //横的图片
        self.scrollView.maximumZoomScale = floor(self.tz_height / _imageContainerView.tz_height) > 2.5f ? floor(self.tz_height / _imageContainerView.tz_height) : 2.5f;
    }
    _scrollView.contentSize = CGSizeMake(self.tz_width, MAX(_imageContainerView.tz_height, self.tz_height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= self.tz_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.canDoubleTap) {
        if (_scrollView.zoomScale > 1.0) {
            [_scrollView setZoomScale:1.0 animated:YES];
        } else {
            CGPoint touchPoint = [tap locationInView:self.imageView];
            CGFloat newZoomScale = _scrollView.maximumZoomScale;
            CGFloat xsize = self.frame.size.width / newZoomScale;
            CGFloat ysize = self.frame.size.height / newZoomScale;
            [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
