//
//  LXFBrowserCollectionViewCell.h
//  KDSLife
//
//  Created by PChome on 2017/3/22.
//
//

#import <UIKit/UIKit.h>

@interface LXFBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIViewController *masterViewController;

@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^longPressGestureBlock)(NSData *data);
@property (nonatomic, copy) void (^didShareToSocial)(NSData *data);

- (void)setUrlStr:(NSString *)urlStr andThumbStr:(NSString *)thumbStr;
- (void)setImage:(UIImage *)image;

@end
