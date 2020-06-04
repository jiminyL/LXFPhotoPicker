//
//  ActivityView.m
//  iBuilding
//
//  Created by 梁啸峰 on 2017/9/5.
//
//

#import "ActivityView.h"

//#import "YLImageView.h"
//#import "YLGIFImage.h"

@interface ActivityView()

@property (nonatomic, copy) NSArray<UIImage *> *images;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ActivityView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self refreshViews];
}

- (void)refreshViews
{    
    [self.imageView setFrame:self.bounds];
    [self.imageView setAnimationImages:self.images];
    [self.imageView startAnimating];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setAnimationDuration:1];
        [_imageView setAnimationRepeatCount:0];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (NSArray<UIImage *> *)images
{
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (int i=1; i<=3; i++) {
        NSString *name = [NSString stringWithFormat:@"jiazai_%d", i];
        UIImage *image = [UIImage imageNamed:name];
        [resultArr addObject:image];
    }
    return resultArr;
}


@end
